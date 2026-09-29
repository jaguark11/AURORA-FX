# AURORA-FX
### High-Performance Stochastic Grid Resilience Engine — Modern Fortran 2008

AURORA-FX is a numerical resilience laboratory for electric power networks. It combines DC power-flow, N-1 contingency screening, Monte-Carlo component failures, tail-risk metrics (VaR/CVaR), graph spectral diagnostics, and a greedy emergency stabilization policy in a compact HPC-oriented Fortran codebase.

**Origin ID:** `AURORA-FX-KRISTIAN-20260929-7F3C9A11`  
**Original author:** Kristian

## Why Fortran?
Modern Fortran remains unusually strong for numerical/HPC workloads: native arrays, predictable compiled performance, mature compilers, and direct access to BLAS/LAPACK/MPI ecosystems. This project intentionally demonstrates engineering outside the usual web stack.

## Core mathematics
- Linearized DC load flow: `B θ = P`
- Branch power: `F_ij = (θ_i - θ_j) / x_ij`
- N-1 screening by topology mutation and re-solve
- Monte-Carlo random outages
- Value-at-Risk and Conditional Value-at-Risk at 95%
- Spectral radius of the grid adjacency matrix via power iteration
- Nonlinear overload risk transformation
- Emergency load-shedding heuristic under a max-loading target

## Build
```bash
make
./build/aurora_fx demo
```

## Commands
```bash
./build/aurora_fx demo
./build/aurora_fx contingency
./build/aurora_fx montecarlo
./build/aurora_fx stabilize
./build/aurora_fx provenance
make test
make verify-origin
```

Custom CSV cases are accepted:
```bash
./build/aurora_fx demo path/to/buses.csv path/to/branches.csv
```

## Provenance / anti-replica layer
A public repository can always be copied. AURORA-FX therefore uses **tamper-evident provenance**, not fake copy protection:

1. Embedded immutable-looking Origin ID in the binary.
2. `AUTHORS` and `CITATION.cff` identifying the original author.
3. `.well-known/provenance.json` containing SHA-256 hashes of protected files.
4. `scripts/verify_origin.py` for local integrity verification.
5. Optional `scripts/sign_release.sh` integration with Sigstore/cosign for real cryptographic release signatures.
6. Restrictive source-available license requiring preservation of attribution.

Run `make verify-origin` after cloning. If protected files were altered, the verifier reports tampering.

## Repository map
- `src/` numerical kernels and domain modules
- `app/` CLI
- `tests/` deterministic smoke tests
- `data/` synthetic grid case
- `docs/` architecture, mathematics, validation and threat model
- `scripts/` provenance and signing helpers
- `benchmarks/` benchmark notes

## Safety / scope
This is an engineering simulation tool. It does **not** connect to real SCADA equipment, protective relays, or utility control systems. Real-grid operational use requires validated models, domain review, regulatory compliance, and extensive verification.
