# Benchmarks

The baseline benchmark target is intentionally dependency-free. Suggested measurements include solve latency versus bus count, N-1 total runtime versus branch count, and Monte-Carlo throughput versus scenario count.

Use `/usr/bin/time -v ./build/aurora_fx montecarlo` after compiling with `-O3 -march=native` for local measurements.
