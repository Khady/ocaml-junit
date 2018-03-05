(** Interface to product JUnit reports for Alcotest

    It tries to provide a layer as thin as possible on top of Alcotest
    to allow to port existing test without writing a lot a boilerplate.
*)

val wrap_test :
  (Junit.Testcase.t -> unit) ->
  unit Alcotest.test_case ->
  unit Alcotest.test_case
(** [wrap_test handle_result test_cases] wraps test cases to create
    Junit testcases and pass them to [handle_result].

    Can be used with {!run} to create customized Junit testsuites if
    the output of {!run_and_report} is not as expected.
*)

val run: ?argv:string array -> string -> unit Alcotest.test list -> unit
(** [run ?argv n t] is a wrapper around {!Alcotest.run}, only setting
    [and_exit] to false. It is mandatory to be able to process results
    after the end of the run.

    Low level function. It is easier to use {!run_and_report}.
*)

val run_and_report:
  ?package:string ->
  ?timestamp:Ptime.t ->
  ?argv:string array ->
  string ->
  (string * unit Alcotest.test_case list) list ->
  Junit.Testsuite.t
(** [run name tests] is a wrapper around {!run} and {!wrap_test}. It
    runs the tests and creates a Junit testsuite from the results.

    [?argv] is forwarded to {!run}.
    [?package] and [?timestamp] and forwarded to {!Junit.Testsuite.make}.
*)
