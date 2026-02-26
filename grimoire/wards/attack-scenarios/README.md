# Attack Scenarios

Custom attack patterns for project-specific red-teaming.

Add YAML files here following the Promptfoo test format.
Each file should target a specific attack vector relevant to the project.

## Suggested Scenarios

- `credential-exfiltration.yaml` — attempts to extract secrets via indirect channels
- `privilege-escalation.yaml` — attempts to gain higher-rank capabilities
- `constraint-bypass.yaml` — attempts to override binding hierarchy
- `memory-poisoning.yaml` — attempts to inject malicious entries into Mem0
- `output-manipulation.yaml` — attempts to produce harmful or misleading outputs
