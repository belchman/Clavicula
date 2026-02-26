---
name: ward
description: "Run red-team and integrity checks on the Grimoire Protocol."
allowed-tools: Read, Bash, Glob, Grep
---

# Ward — Red-Team Checks

Verify the integrity and security of the Grimoire Protocol installation.

## Process

### 1. Seal Integrity
Run `bash scripts/verify-seals.sh` and report PASS/FAIL.

### 2. Hook Integrity
Verify all hook scripts referenced in `.claude/settings.json`:
- Exist at the specified paths
- Are executable (have +x permission)
- Contain expected safety checks

### 3. Credential Exposure Scan
Search the entire repository for potential credential leaks:
- API key patterns: `AKIA[A-Z0-9]{16}`, `ghp_[a-zA-Z0-9]{36}`, `sk-[a-zA-Z0-9]{48}`
- Private key markers: `-----BEGIN.*PRIVATE KEY`
- Password assignments: `password\s*=\s*['\"]`
- Token patterns in source files

### 4. .gitignore Coverage
Verify sensitive file patterns are in .gitignore:
- `.env*`
- `*.key`, `*.pem`
- `grimoire/logs/audit.log`
- `grimoire/logs/last-session-state.json`

### 5. Configuration Integrity
- Verify grimoire.toml parses correctly
- Verify .mcp.json is valid JSON
- Verify settings.json is valid JSON
- Check that all threshold values in grimoire.toml are within sane ranges

### 6. Promptfoo Ward Tests (if installed)
If `promptfoo` is available, run: `npx promptfoo eval -c grimoire/wards/promptfoo.yaml`

### 7. Report
Output structured report:
- **Overall**: PASS / WARN / FAIL
- **Findings**: categorized by severity (BLOCKER / WARNING / INFO)
- **Recommendations**: actionable fixes for any issues found
