build:
	jbuilder build

doc:
	jbuilder build @doc

test:
	jbuilder runtest

examples:
	jbuilder build @examples/examples

clean:
	jbuilder clean

.PHONY: examples doc test build
