# Architecture

AURORA-FX is intentionally layered so the numerical kernels remain independent from I/O and CLI code.

`grid_io -> grid_types -> dc_powerflow -> risk_metrics -> contingency / monte_carlo / optimizer`

`graph_metrics` computes topology-level indicators independent of power-flow state. `provenance` exposes the embedded origin record from the compiled binary.

The current implementation uses dense matrices for auditability and portability. A production HPC branch would replace the dense susceptance solve with CSR sparse storage plus a preconditioned Krylov solver, and distribute Monte-Carlo scenarios using coarrays or MPI.
