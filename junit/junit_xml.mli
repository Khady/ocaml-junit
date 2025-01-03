(** Low level interface to build XML elements. *)

(** This module defines basic data types for data, attributes and
    element occuring in JUnit reports.

    It is based on the XSD provided in
    {{:https://github.com/windyroad/JUnit-Schema} JUnit-schema} git
    repository.

    Those are low level functions. Values like [id], [failures] or
    [tests] will not be checked.

    It allows you to build a report by hand if the facilities that are
    offered by {!module:Junit} do not suit your needs. *)

(** {2 Categories of elements and attributes} *)

(** This part defines the categories of elements and attributes. *)

(** {3 Attributes} *)

(** https://www.w3.org/TR/xmlschema-2/#token

    [Definition:] token represents tokenized strings. The ·value space· of
    token is the set of strings that do not contain the carriage return
    (#xD), line feed (#xA) nor tab (#x9) characters, that have no
    leading or trailing spaces (#x20) and that have no internal
    sequences of two or more spaces. The ·lexical space· of token is
    the set of strings that do not contain the carriage return (#xD),
    line feed (#xA) nor tab (#x9) characters, that have no leading or
    trailing spaces (#x20) and that have no internal sequences of two
    or more spaces. The ·base type· of token is normalizedString. *)
type token = string

type timestamp

val timestamp : Ptime.t -> timestamp

(** {3 Elements} *)

(** {4 Properties} *)

type property

(** Properties (e.g., environment settings) set during test execution. *)
type properties = property list

val property : name:token -> value:string -> property

(** Builds an XML element from a property. *)
val property_to_xml : property -> Tyxml.Xml.elt

(** {4 Testcases} *)

(** Indicates that the test errored. An errored test is one that had
    an unanticipated problem. e.g., an unchecked throwable; or a problem
    with the implementation of the test. Contains as a text node
    relevant data for the error, e.g., a stack trace. *)
type error =
  { message : string option
  ; typ : string
  ; description : string
  }

(** [error ?message ~typ description] creates an error element.

    @param message
      The error message. e.g., if a java exception is
      thrown, the return value of getMessage().

    @param typ
      The type of error that occured. e.g., if a java
      execption is thrown the full class name of the exception.

    @param description Description of the error. *)
val error : ?message:string -> typ:string -> string -> error

(** Builds an XML element from a error. *)
val error_to_xml : error -> Tyxml.Xml.elt

(** Indicates that the test failed. A failure is a test which the code
    has explicitly failed by using the mechanisms for that purpose. e.g.,
    via an assertEquals. Contains as a text node relevant data for the
    failure, e.g., a stack trace. *)
type failure =
  { message : string option
  ; typ : string
  ; description : string
  }

(** [failure ?message ~typ description] creates a failure element.

    @param message The message specified in the assert.
    @param typ The type of the assert.
    @param description Description of the failure. *)
val failure : ?message:string -> typ:string -> string -> failure

(** Builds an XML element from a failure. *)
val failure_to_xml : failure -> Tyxml.Xml.elt

type result =
  | Error of error
  | Failure of failure
  | Pass
  | Skipped (** Not part of the spec, but available in jenkins. *)

(** Builds an XML element from a result. *)
val result_to_xml : result -> Tyxml.Xml.elt

type testcase
type testcases = testcase list

(** Creates a testcase.

    @param name Name of the test method.

    @param classname Full class name for the class the test method is
                     in.

    @param time Time taken (in seconds) to execute the test.

    @param result Result of the test. *)
val testcase : name:token -> classname:token -> time:float -> result -> testcase

(** Builds an XML element from a testcase. *)
val testcase_to_xml : testcase -> Tyxml.Xml.elt

(** {4 Testsuites} *)

(** Contains the results of executing a testsuite. *)
type testsuite

(** Contains an aggregation of testsuite results. *)
type testsuites = testsuite list

(** Creates a testsuite.

    Attributes

    @param package Derived from the testsuite name in the non-aggregated
                   documents.

    @param id
      Starts at 0 for the first testsuite and is incremented
      by 1 for each following testsuite.

    @param name
      Full class name of the test for non-aggregated
      testsuite documents. Class name without the package for aggregated
      testsuites documents.

    @param timestamp When the test was executed. Timezone may not be
                     specified.

    @param hostname
      Host on which the tests were executed. 'localhost'
      should be used if the hostname cannot be determined.

    @param tests
      The total number of tests in the suite.The total
      number of tests in the suite.

    @param failures
      The total number of tests in the suite that
      failed. A failure is a test which the code has explicitly failed
      by using the mechanisms for that purpose. e.g., via an
      assertEquals.

    @param errors
      The total number of tests in the suite that
      errored. An errored test is one that had an unanticipated
      problem. e.g., an unchecked throwable; or a problem with the
      implementation of the test.

    @param skipped The total number of tests in the suite that
    were skipped. A skipped test is one that was not run because
    the conditions for running it were not met.

    @param time Time taken (in seconds) to execute the tests in the
                suite.

                Elements

    @param properties Properties (e.g., environment settings) set
                      during test execution.

    @param testcases List of test executed.

    @param system_out Data that was written to standard out while the
                      test was executed.

    @param system_err Data that was written to standard error while
                      the test was executed. *)
val testsuite
  :  ?system_out:string
  -> ?system_err:string
  -> package:token
  -> id:int
  -> name:token
  -> timestamp:timestamp
  -> hostname:token
  -> tests:int
  -> failures:int
  -> errors:int
  -> skipped:int
  -> time:float
  -> properties
  -> testcases
  -> testsuite

(** Builds an XML element from a testsuite. *)
val testsuite_to_xml : testsuite -> Tyxml.Xml.elt

(** Builds an XML element from a list of testsuites. *)
val to_xml : testsuites -> Tyxml.Xml.elt
