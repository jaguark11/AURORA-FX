# Validation strategy

The repository ships with a deterministic synthetic network and tests for parsing, dimensional consistency, DC-flow solvability, bounded risk scoring, finite loading, and N-1 screening.

For production validation, add benchmark cases from an independently validated power-system dataset and compare against a trusted solver. The implementation is educational/research-grade and should not be used to control physical infrastructure without domain-specific verification.
