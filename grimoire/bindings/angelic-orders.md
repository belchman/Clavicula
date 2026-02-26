# Angelic Orders — System-Level Policies

These policies govern all agent behavior at the system level. They may be
updated by the human operator but not by any agent. They are subordinate
only to the Divine Names.

## Data Handling

- No PII (names, emails, phone numbers, addresses) in log files or audit trails
- No credentials in committed files — use .gitignore patterns
- No raw database queries without parameterized inputs
- Sanitize all external input before processing
- Respect data retention policies defined in project documentation

## Code Quality

- All code changes must be verified (tests pass, types check, lints clean)
- Follow existing project conventions — detect and match, don't impose
- Commit after each verified implementation step
- Commit messages follow conventional format: `type(scope): description`
- Never commit secrets, credentials, or .env files
- The human user is the sole author. Claude is never listed as co-author.

## Communication

- No external HTTP requests without explicit allowlist in agent Seal
- No email/Slack/webhook triggers without human approval
- API rate limits must be respected — use exponential backoff
- Log all external communications to audit trail

## Security

- Dependencies must be pinned to exact versions when adding new ones
- No eval(), exec(), or dynamic code execution on user input
- Input validation required on all external data boundaries
- No hardcoded secrets — use environment variables or secret managers
- Apply principle of least privilege to all resource access

## Portability

- No grep -oP (PCRE is not portable to macOS/BSD)
- No hardcoded paths when config variables exist in grimoire.toml
- TTY-aware colors: wrap ANSI codes in `if [ -t 1 ]` checks
- All tunable values pass through grimoire.toml
