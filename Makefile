FC = gfortran
FFLAGS ?= -O2 -std=f2008 -Wall -Wextra -fcheck=all -Jbuild -Ibuild
SRC = src/kinds.f90 src/grid_types.f90 src/linalg.f90 src/grid_io.f90 src/dc_powerflow.f90 src/risk_metrics.f90 src/graph_metrics.f90 src/contingency.f90 src/monte_carlo.f90 src/resilience_optimizer.f90 src/provenance.f90

.PHONY: all clean test demo verify-origin
all: build/aurora_fx

build:
	mkdir -p build

build/aurora_fx: build $(SRC) app/main.f90
	$(FC) $(FFLAGS) $(SRC) app/main.f90 -o $@

build/test_core: build $(SRC) tests/test_core.f90
	$(FC) $(FFLAGS) $(SRC) tests/test_core.f90 -o $@

test: build/test_core
	./build/test_core

demo: build/aurora_fx
	./build/aurora_fx demo

verify-origin:
	python3 scripts/verify_origin.py

clean:
	rm -rf build

build/test_montecarlo: build $(SRC) tests/test_montecarlo.f90
	$(FC) $(FFLAGS) $(SRC) tests/test_montecarlo.f90 -o $@

test-all: build/test_core build/test_montecarlo
	./build/test_core
	./build/test_montecarlo
	python3 scripts/verify_origin.py
