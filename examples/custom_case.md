# Custom case format

`buses.csv`: `id,demand,generation`

`branches.csv`: `from_bus,to_bus,reactance,limit`

Bus identifiers may be non-contiguous, but the slack bus currently refers to the first loaded bus index in the CLI.
