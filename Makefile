build:
	jbuilder build --dev

doc:
	jbuilder build @doc

test:
	jbuilder runtest --dev

examples:
	jbuilder build @examples/examples

clean:
	jbuilder clean

.PHONY: examples doc test build
