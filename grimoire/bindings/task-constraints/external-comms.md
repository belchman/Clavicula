# External Communications Constraints

Task-level constraints for all external service interactions.
These are subordinate to Divine Names and Angelic Orders.

## API Calls

- All external API calls must use authenticated connections (TLS 1.2+)
- Implement circuit breakers for all external service calls
- Respect rate limits — implement exponential backoff with jitter
- Set appropriate timeouts on all HTTP requests (connect: 5s, read: 30s)
- Log all external API calls to audit trail (without sensitive headers/bodies)

## Webhook Handling

- Validate webhook signatures before processing payloads
- Process webhooks idempotently — handle duplicate deliveries
- Respond with 200 immediately, process asynchronously
- Log all received webhooks with correlation IDs

## Message Queues

- Messages must be idempotent — safe to process more than once
- Implement dead letter queues for failed messages
- Set appropriate visibility timeouts
- Monitor queue depth and alert on growth

## Email and Notifications

- Never send emails or notifications without human approval
- Use templates for all outbound communications
- Include unsubscribe mechanisms where legally required
- Log all outbound communications

## Third-Party Service Dependencies

- Document all external service dependencies with SLA expectations
- Implement graceful degradation when external services are unavailable
- Cache external responses where appropriate to reduce dependency
- Monitor external service health and alert on degradation
