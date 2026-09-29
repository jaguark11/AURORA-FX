# Mathematical model

## DC power flow
Under the usual lossless small-angle approximation, active-power balance is modeled as `Bθ=P`, where `B` is the nodal susceptance matrix. One slack-bus row/column is removed to make the reduced system nonsingular. Branch flow is `(θ_i-θ_j)/x_ij`.

## Risk transformation
A branch loading ratio `r=|F|/limit` contributes only after the 0.8 utilization threshold. Aggregate stress is transformed with `1-exp(-3*sum(max(0,r-0.8)^2))`, keeping the score in `[0,1)`.

## Tail risk
Monte-Carlo outcomes are summarized using empirical VaR and CVaR at 95%. CVaR averages the worst tail rather than only reporting a quantile.

## Spectral topology
Power iteration estimates the dominant eigenvalue magnitude of the undirected adjacency matrix. It is included as a topology diagnostic, not as a complete stability proof.

## Emergency stabilization
The baseline optimizer repeatedly reduces the largest non-slack load until the post-solve maximum branch loading drops below a target. It is deliberately simple and auditable; future variants can replace it with LP/QP/OPF formulations.
