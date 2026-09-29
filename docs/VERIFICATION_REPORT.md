# Verification report — v0.1.0

Verification date: 2026-09-29
Compiler used: GNU Fortran (gfortran)
Standard target: Fortran 2008

## Automated checks

- CSV grid parser: PASS
- DC power-flow solve: PASS
- Flow-vector dimensional consistency: PASS
- Finite loading metric: PASS
- Risk score bounded in [0,1]: PASS
- N-1 worst-branch selection: PASS
- Monte-Carlo output bounded in [0,1]: PASS
- CVaR95 >= VaR95 invariant: PASS
- Protected-file SHA-256 provenance verification: PASS

## Deterministic sample results

- Spectral radius: 3.1464
- Base risk score: 0.5537
- Base maximum branch loading: 1.2098 p.u. of configured limit
- Worst N-1 outage branch: 1
- Worst N-1 loading: 2.3889
- Monte-Carlo trials: 1000
- Mean stochastic risk: 0.60135
- VaR95: 0.99936
- CVaR95: 0.99962
- Emergency stabilization load shed: 45.8571 model units
- Final maximum loading after stabilization: 0.9359

These values are for the bundled synthetic case and are regression evidence, not claims about a real electrical system.
