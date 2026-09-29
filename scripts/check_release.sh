#!/usr/bin/env bash
set -euo pipefail
make clean
make
make test-all
./build/aurora_fx demo >/tmp/aurora_demo.txt
./build/aurora_fx contingency >/tmp/aurora_contingency.txt
./build/aurora_fx montecarlo >/tmp/aurora_montecarlo.txt
./build/aurora_fx stabilize >/tmp/aurora_stabilize.txt
./build/aurora_fx provenance >/tmp/aurora_provenance.txt
echo 'AURORA-FX release verification: PASS'
