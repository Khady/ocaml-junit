(** Interface from OUnit result to JUnit reports *)

val of_result : OUnit.test_result -> Junit.Testcase.t

(** [of_results ~name l] converts the list of results [l] into a
    Junit testsuite named [name]. *)
val of_results : name:string -> OUnit.test_results -> Junit.Testsuite.t

(** Shortcut: converts the test results to a Junit testsuite, and dump
    it into the given file as XML. *)
val to_file : name:string -> string -> OUnit.test_results -> unit
