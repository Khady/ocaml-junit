(** High level interface to produce JUnit reports. *)

(** This module defines functions to create JUnit reports and export
    them to XML.
*)

module Property :
sig
  (** Properties (e.g., environment settings) set during test execution. *)

  type t

  val make :
    name:string ->
    value:string ->
    t
end

module Testcase :
sig
  type t

  type error
  (** Indicates that the test errored. An errored test is one that had
      an unanticipated problem. e.g., an unchecked throwable; or a
      problem with the implementation of the test. Contains as a text
      node relevant data for the error, e.g., a stack trace.
*)

  type failure
  (** Indicates that the test failed. A failure is a test which the
      code has explicitly failed by using the mechanisms for that
      purpose. e.g., via an assertEquals. Contains as a text node
      relevant data for the failure, e.g., a stack trace.
*)

  type result =
    | Error of error
    | Failure of failure
    | Pass
    | Skipped

  val error :
    ?message:string ->
    typ:string ->
    string ->
    error
  (** Creates an error element.

      @param message The error message. e.g., if a java exception is
      thrown, the return value of getMessage().

      @param typ The type of error that occured. e.g., if a java
      execption is thrown the full class name of the exception.

      @param description Description of the error.
  *)

  val failure :
    ?message:string ->
    typ:string ->
    string ->
    failure
  (** Creates a failure element.

      @param message The message specified in the assert.
      @param typ The type of the assert.
      @param description Description of the failure.
  *)

  val make :
    name:string ->
    classname:string ->
    time:float ->
    result ->
    t
end

module Testsuite :
sig
  (** Contains the results of executing a testsuite. *)

  type t

  val make :
    ?package:string ->
    ?timestamp:Ptime.t ->
    ?hostname:string ->
    ?system_out:string ->
    ?system_err:string ->
    name:string ->
    t
  (** Creates a testsuite.

      Attributes

      @param package Derived from the testsuite name in the
      non-aggregated documents.

      @param timestamp When the test was executed. Timezone may not be
      specified. Uses the current time by default.

      @param hostname Host on which the tests were executed. Uses
      [localhost] by default.

      @param system_out Data that was written to standard out while
      the test was executed.

      @param system_err Data that was written to standard error while
      the test was executed.

      @param name Full class name of the test for non-aggregated
      testsuite documents. Class name without the package for
      aggregated testsuites documents.
*)

  val add_testcases :
    Testcase.t list -> t -> t

  val add_properties :
    Property.t list -> t -> t
end

type t
(** Contains an aggregation of testsuite results. *)

val make : Testsuite.t list ->  t
val add_testsuite : Testsuite.t -> t -> t
val to_xml : t -> Xml.elt
