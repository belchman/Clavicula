#!/usr/bin/env python3
"""
Grimoire Protocol — Epic Readiness Gate

Validates that Epics being moved to "Ready" status comply with The Way:
  - Epic must include a PR-FAQ document
  - Epic must include at least one Story
  - All Stories in the Epic must include valid Gherkin specification code

Supports: Beads (.beads/issues.jsonl) and Kanbus (project/issues/*.json)

Exit 0 = pass, Exit 1 = violation detected.
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path


def get_staged_files():
    """Return list of staged file paths."""
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
        capture_output=True, text=True
    )
    return [f.strip() for f in result.stdout.strip().split("\n") if f.strip()]


def get_staged_content(filepath):
    """Read the staged version of a file (not the working tree version)."""
    result = subprocess.run(
        ["git", "show", f":{filepath}"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return None
    return result.stdout


def get_head_content(filepath):
    """Read the HEAD version of a file for diffing."""
    result = subprocess.run(
        ["git", "show", f"HEAD:{filepath}"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return None
    return result.stdout


def has_prfaq(description):
    """Check if text contains PR-FAQ content markers."""
    if not description:
        return False
    markers = [
        r"(?i)pr-?faq",
        r"(?i)press\s+release",
        r"(?i)##\s*faq",
        r"(?i)##\s*customer\s+faq",
        r"(?i)##\s*internal\s+faq",
    ]
    return any(re.search(m, description) for m in markers)


def has_prfaq_artifact(epic_title):
    """Check if a PR-FAQ artifact file exists for this epic."""
    slug = re.sub(r"[^a-z0-9]+", "-", epic_title.lower()).strip("-")
    artifacts_dir = Path("docs/artifacts")
    if not artifacts_dir.exists():
        return False
    for f in artifacts_dir.iterdir():
        if f.name.startswith("pr-faq") and f.suffix == ".md":
            return True
    # Also check for slug-specific file
    return (artifacts_dir / f"pr-faq-{slug}.md").exists()


def has_gherkin(text):
    """Check if text contains valid Gherkin specification code."""
    if not text:
        return False
    gherkin_patterns = [
        r"(?m)^\s*Feature:",
        r"(?m)^\s*Scenario:",
        r"(?m)^\s*Given\s+",
        r"(?m)^\s*When\s+",
        r"(?m)^\s*Then\s+",
    ]
    # Must have at least Feature/Scenario and one Given/When/Then
    has_structure = any(re.search(p, text) for p in gherkin_patterns[:2])
    has_steps = any(re.search(p, text) for p in gherkin_patterns[2:])
    return has_structure and has_steps


def is_newly_ready(old_issue, new_issue):
    """Check if an issue is being moved TO ready status."""
    old_labels = set(old_issue.get("labels", [])) if old_issue else set()
    new_labels = set(new_issue.get("labels", []))

    old_status = (old_issue.get("status", "") if old_issue else "").lower()
    new_status = new_issue.get("status", "").lower()

    # Check if "ready" label is being added
    ready_label_added = "ready" in new_labels and "ready" not in old_labels

    # Check if status is being changed to "ready"
    ready_status_set = new_status == "ready" and old_status != "ready"

    return ready_label_added or ready_status_set


def is_ready(issue):
    """Check if an issue currently has ready status/label."""
    labels = [l.lower() if isinstance(l, str) else l for l in issue.get("labels", [])]
    status = issue.get("status", "").lower()
    return "ready" in labels or status == "ready"


# ─── Beads (.beads/issues.jsonl) ───────────────────────────────────────────────

def validate_beads(staged_files):
    """Validate Epic readiness for Beads PM tool."""
    jsonl_files = [f for f in staged_files if f.endswith("issues.jsonl") and ".beads" in f]
    if not jsonl_files:
        return []

    violations = []

    for jsonl_path in jsonl_files:
        staged = get_staged_content(jsonl_path)
        head = get_head_content(jsonl_path)

        if not staged:
            continue

        # Parse staged issues
        staged_issues = {}
        for line in staged.strip().split("\n"):
            if not line.strip():
                continue
            try:
                issue = json.loads(line)
                staged_issues[issue["id"]] = issue
            except (json.JSONDecodeError, KeyError):
                continue

        # Parse HEAD issues for comparison
        head_issues = {}
        if head:
            for line in head.strip().split("\n"):
                if not line.strip():
                    continue
                try:
                    issue = json.loads(line)
                    head_issues[issue["id"]] = issue
                except (json.JSONDecodeError, KeyError):
                    continue

        # Collect epics to validate:
        # 1. Epics being moved to Ready
        # 2. Already-ready epics whose children changed
        epics_to_validate = set()

        for issue_id, issue in staged_issues.items():
            issue_type = issue.get("issue_type", "").lower()

            if issue_type == "epic":
                old_issue = head_issues.get(issue_id)
                if is_newly_ready(old_issue, issue):
                    epics_to_validate.add(issue_id)

            # If a story changed, check if its parent epic is ready
            if issue_type in ("story", "feature", "task"):
                for dep in issue.get("dependencies", []):
                    if dep.get("type") == "parent-child":
                        parent_id = dep.get("depends_on_id") or dep.get("issue_id")
                        if parent_id and parent_id in staged_issues:
                            parent = staged_issues[parent_id]
                            if parent.get("issue_type", "").lower() == "epic" and is_ready(parent):
                                epics_to_validate.add(parent_id)

        for epic_id in epics_to_validate:
            if epic_id in staged_issues:
                epic = staged_issues[epic_id]
                epic_violations = validate_epic_beads(epic, staged_issues)
                if epic_violations:
                    violations.append((epic, epic_violations))

    return violations


def validate_epic_beads(epic, all_issues):
    """Validate a single Beads epic against the readiness gate."""
    findings = []
    epic_id = epic["id"]
    title = epic.get("title", epic_id)

    # 1. Check PR-FAQ
    desc = epic.get("description", "") or ""
    notes = epic.get("notes", "") or ""
    if not has_prfaq(desc) and not has_prfaq(notes) and not has_prfaq_artifact(title):
        findings.append("Epic has no PR-FAQ document")

    # 2. Find child stories
    children = []
    for issue in all_issues.values():
        deps = issue.get("dependencies", [])
        for dep in deps:
            if dep.get("depends_on_id") == epic_id and dep.get("type") == "parent-child":
                children.append(issue)
                break
            if dep.get("issue_id") == epic_id and dep.get("type") == "parent-child":
                children.append(issue)
                break

    # Also check if any issue lists this epic as a parent via other means
    stories = [c for c in children if c.get("issue_type", "").lower() in ("story", "feature", "task")]

    if not stories:
        findings.append("Epic has no Stories")
    else:
        # 3. Check Gherkin in each story
        for story in stories:
            story_desc = story.get("description", "") or ""
            story_notes = story.get("notes", "") or ""
            if not has_gherkin(story_desc) and not has_gherkin(story_notes):
                findings.append(
                    f"Story \"{story.get('title', story['id'])}\" has no Gherkin specification"
                )

    return findings


# ─── Kanbus (project/issues/kanbus-*.json) ────────────────────────────────────

def validate_kanbus(staged_files):
    """Validate Epic readiness for Kanbus PM tool."""
    kanbus_files = [f for f in staged_files if "project/issues/kanbus-" in f and f.endswith(".json")]
    if not kanbus_files:
        return []

    violations = []

    # Load ALL staged kanbus issues (we need the full set to check children)
    issues_dir = Path("project/issues")
    all_issues = {}

    # First load from git index (staged versions)
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
        capture_output=True, text=True
    )
    all_staged = [f.strip() for f in result.stdout.strip().split("\n") if f.strip()]

    # Load all kanbus issues from the working tree + staged
    if issues_dir.exists():
        for f in issues_dir.glob("kanbus-*.json"):
            rel = str(f)
            content = get_staged_content(rel) if rel in all_staged else None
            if not content:
                try:
                    content = f.read_text()
                except Exception:
                    continue
            try:
                issue = json.loads(content)
                all_issues[issue["id"]] = issue
            except (json.JSONDecodeError, KeyError):
                continue

    # Collect epics that need validation:
    # 1. Epics being moved to Ready
    # 2. Already-ready epics whose children are being modified
    epics_to_validate = set()

    for kanbus_path in kanbus_files:
        staged = get_staged_content(kanbus_path)
        head = get_head_content(kanbus_path)

        if not staged:
            continue

        try:
            new_issue = json.loads(staged)
        except json.JSONDecodeError:
            continue

        issue_type = new_issue.get("type", "").lower()

        if issue_type == "epic":
            old_issue = None
            if head:
                try:
                    old_issue = json.loads(head)
                except json.JSONDecodeError:
                    pass

            if is_newly_ready(old_issue, new_issue):
                epics_to_validate.add(new_issue["id"])

        # If a story is being added/modified, check if its parent epic is ready
        if issue_type in ("story", "task", "bug", "feature"):
            parent_id = new_issue.get("parent")
            if parent_id and parent_id in all_issues:
                parent = all_issues[parent_id]
                if parent.get("type", "").lower() == "epic" and is_ready(parent):
                    epics_to_validate.add(parent_id)

    # Validate all identified epics
    for epic_id in epics_to_validate:
        if epic_id in all_issues:
            epic = all_issues[epic_id]
            epic_violations = validate_epic_kanbus(epic, all_issues)
            if epic_violations:
                violations.append((epic, epic_violations))

    return violations


def validate_epic_kanbus(epic, all_issues):
    """Validate a single Kanbus epic against the readiness gate."""
    findings = []
    epic_id = epic["id"]
    title = epic.get("title", epic_id)

    # 1. Check PR-FAQ
    desc = epic.get("description", "") or ""
    if not has_prfaq(desc) and not has_prfaq_artifact(title):
        findings.append("Epic has no PR-FAQ document")

    # 2. Find child stories (issues with parent == this epic's id)
    stories = []
    for issue in all_issues.values():
        if issue.get("parent") == epic_id:
            issue_type = issue.get("type", "").lower()
            if issue_type in ("story", "task", "bug", "feature"):
                stories.append(issue)

    if not stories:
        findings.append("Epic has no Stories")
    else:
        # 3. Check Gherkin in each story
        for story in stories:
            story_desc = story.get("description", "") or ""
            comments_text = " ".join(
                c.get("text", "") for c in story.get("comments", [])
            )
            if not has_gherkin(story_desc) and not has_gherkin(comments_text):
                findings.append(
                    f"Story \"{story.get('title', story['id'])}\" has no Gherkin specification"
                )

    return findings


# ─── GitHub Issues (via labels/metadata in commit) ────────────────────────────

def validate_github(staged_files):
    """
    GitHub Issues are remote — we cannot validate them in a pre-commit hook
    the same way we validate file-based PM tools. Instead, check for PR-FAQ
    artifacts and any local issue metadata files.
    """
    # GitHub validation happens at PR time via gh CLI, not at commit time.
    return []


# ─── Main ─────────────────────────────────────────────────────────────────────

def print_sin(epic, findings):
    """Print a themed error for The Way violation."""
    title = epic.get("title", epic.get("id", "Unknown"))
    print()
    print("═" * 70)
    print("  A SIN AGAINST THE WAY")
    print("═" * 70)
    print()
    print(f"  Epic: \"{title}\"")
    print()
    print("  This Epic cannot advance to Ready. The Way demands:")
    print()
    print("    Given that there is an Epic representing a new feature,")
    print("    When we want to advance that feature to the \"Ready\" status,")
    print("    Then the Epic must include a PR-FAQ document,")
    print("    And the Epic must include at least one Story,")
    print("    And all Stories must include valid Gherkin specification code.")
    print()
    print("  Violations found:")
    for f in findings:
        print(f"    - {f}")
    print()
    print("  The Sacrament of Specification has been broken.")
    print("  No code precedes specification.")
    print("  No specification precedes documentation.")
    print("  Fix these violations before committing.")
    print()
    print("═" * 70)
    print()


def main():
    staged_files = get_staged_files()
    if not staged_files:
        return 0

    all_violations = []

    # Detect PM tool and validate
    beads_files = [f for f in staged_files if ".beads" in f]
    kanbus_files = [f for f in staged_files if "project/issues" in f]

    if beads_files:
        all_violations.extend(validate_beads(staged_files))

    if kanbus_files:
        all_violations.extend(validate_kanbus(staged_files))

    # GitHub Issues are validated at PR time, not commit time
    # (they don't have local files to check)

    if all_violations:
        for epic, findings in all_violations:
            print_sin(epic, findings)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
