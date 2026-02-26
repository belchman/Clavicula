# Security Checklist

## Authentication
- [ ] Auth mechanism implemented and tested
- [ ] Passwords hashed with bcrypt/argon2
- [ ] JWT tokens have appropriate expiry
- [ ] Rate limiting on login endpoint
- [ ] Account lockout after failed attempts

## Authorization
- [ ] RBAC implemented
- [ ] Resource-level permission checks
- [ ] No horizontal privilege escalation

## Input Validation
- [ ] All user input validated and sanitized
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Command injection prevention

## Data Protection
- [ ] PII encrypted at rest
- [ ] TLS 1.2+ in transit
- [ ] No secrets in source code or logs

## API Security
- [ ] CORS configured restrictively
- [ ] Rate limiting on all endpoints
- [ ] Request size limits

## Infrastructure
- [ ] Debug mode disabled in production
- [ ] Dependencies scanned for vulnerabilities
- [ ] Security headers set

## Threat Model

| Threat | Severity | Mitigation | Status |
|--------|----------|------------|--------|
| | | | |

## Related Documents
- **Feeds into:** [OBSERVABILITY.md](OBSERVABILITY.md)
- **Informed by:** [TESTING_PLAN.md](TESTING_PLAN.md)
