# OCaml JUnit

ocaml-junit is a package for the creation of JUnit XML reports. It
provides a typed API to produce valid reports. They are supposed to be
accepted by Jenkins.

It comes with two packages for support of OUnit and Alcotest.

## Installation

```
opam pin add junit https://github.com/Khady/ocaml-junit.git
opam pin add junit_ounit https://github.com/Khady/ocaml-junit.git
opam pin add junit_alcotest https://github.com/Khady/ocaml-junit.git
```

## Documentation

Available [here](https://khady.github.io/ocaml-junit/)

## References:

- [Jenkins](https://github.com/jenkinsci/xunit-plugin/blob/master/src/main/resources/org/jenkinsci/plugins/xunit/types/model/xsd/junit-10.xsd)
- [JUnit-Schema](https://github.com/windyroad/JUnit-Schema/blob/master/JUnit.xsd)
- [Windyroad](http://windyroad.com.au/dl/Open%20Source/JUnit.xsd)
- [a gist](https://gist.github.com/erikd/4192748)

Those files are archived in directory [`schemes`](schemes)

License: LGPL either version 3 of the License, or (at your option) any
later version with OCaml linking exception.
