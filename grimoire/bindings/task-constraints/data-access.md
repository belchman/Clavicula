# Data Access Constraints

Task-level constraints for all database and data store operations.
These are subordinate to Divine Names and Angelic Orders.

## Query Safety

- All queries must use parameterized inputs — no string concatenation
- All queries must have appropriate indexes documented
- Bulk operations must use batch processing with configurable batch sizes
- Long-running queries must have timeouts

## Connection Management

- Use connection pooling — never create connections per-request
- Close connections in finally/defer blocks
- Set appropriate connection limits per environment
- Handle connection failures with retry and exponential backoff

## Data Integrity

- Use transactions for multi-step operations
- Implement optimistic locking where concurrent updates are possible
- Validate data at the application layer before writing
- Use database constraints (NOT NULL, UNIQUE, FOREIGN KEY) as a safety net

## Migration Safety

- Migrations must be backwards-compatible (expand-contract pattern)
- Test migrations against a copy of production-scale data
- Never drop columns or tables in the same release that removes code using them
- Include rollback migrations for every forward migration

## Sensitive Data

- PII must be encrypted at rest
- Access to PII must be logged
- Data exports must respect data classification levels
- Implement data retention policies — auto-delete expired records
