build:
	dune build

doc:
	dune build @doc

test:
	dune runtest

clean:
	dune clean

fmt:
	dune build @fmt --auto-promote

.PHONY: examples doc test build fmt
