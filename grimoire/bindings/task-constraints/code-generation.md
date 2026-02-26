# Code Generation Constraints

Task-level constraints for all code generation activities.
These are subordinate to Divine Names and Angelic Orders.

## Language Agnostic Standards

- Auto-detect project language, framework, and conventions before generating code
- Match existing code style exactly — indentation, naming, patterns
- Generated code must include error handling for all I/O operations
- No hardcoded values — use configuration or environment variables
- Maximum function/method length: 50 lines (suggest decomposition for longer)
- Generated code must be idiomatic for the project's language and framework

## Testing Requirements

- Every new function/method must have corresponding test coverage
- Tests must follow the project's existing test patterns
- Test names must describe the behavior being tested
- Prefer integration tests over unit tests when testing I/O boundaries

## Documentation

- Public APIs must have documentation (docstrings, JSDoc, GoDoc, etc.)
- Complex logic must have inline comments explaining the "why"
- Do not add documentation to private/internal functions unless logic is non-obvious

## Security

- Validate all inputs at system boundaries
- Use parameterized queries for all database operations
- Escape output appropriately for the rendering context
- Never log sensitive data (passwords, tokens, PII)
- Use constant-time comparison for security-sensitive string comparisons

## Dependencies

- Prefer standard library solutions over external dependencies
- When adding a dependency, pin to exact version
- Justify every new dependency in the commit message
- Check for known vulnerabilities before adding
