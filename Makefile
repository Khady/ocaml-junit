build:
	jbuilder build --dev

doc:
	jbuilder build @doc

test:
	jbuilder runtest --dev

clean:
	jbuilder clean

.PHONY: examples doc test build
