(* Encode this example (from http://help.catchsoftware.com/display/ET/JUnit+Format):

<testsuites>
  <testsuite name="JUnitXmlReporter" errors="0" tests="0" failures="0"
             time="0" timestamp="2013-05-24T10:23:58" />
  <testsuite name="JUnitXmlReporter.constructor" errors="0" skipped="1"
             tests="3" failures="1" time="0.006" timestamp="2013-05-24T10:23:58">
    <properties>
      <property name="java.vendor" value="Sun Microsystems Inc." />
      <property name="compiler.debug" value="on" />
      <property name="project.jdk.classpath" value="jdk.classpath.1.6" />
    </properties>
    <testcase classname="JUnitXmlReporter.constructor"
              name="should default path to an empty string"
              time="0.006">
      <failure message="test failure">Assertion failed</failure>
    </testcase>
    <testcase classname="JUnitXmlReporter.constructor"
              name="should default consolidate to true"
              time="0">
      <skipped />
    </testcase>
    <testcase classname="JUnitXmlReporter.constructor"
              name="should default useDotNotation to true"
              time="0" />
  </testsuite>
</testsuites>

*)

let () =
  let junitXmlReporter = Junit.Testsuite.make "JUnitXmlReporter" in
  let junitXmlReportConstructor =
    let properties =
      [
        Junit.Property.make ~name:"java.vendor" ~value:"Sun Microsystems Inc.";
        Junit.Property.make ~name:"compiler.debug" ~value:"on";
        Junit.Property.make ~name:"project.jdk.classpath" ~value:"jdk.classpath.1.6";
      ]
    in
    let testcases =
      [
        Junit.Testcase.make
          ~name:"should default path to an empty string"
          ~classname:"JUnitXmlReporter.constructor"
          ~time:0.006
          Junit.Testcase.(Failure (failure ~message:"test failure" ~typ:"not equal" "Assertion failed"));
        Junit.Testcase.make
          ~name:"should default consolidate to true"
          ~classname:"JUnitXmlReporter.constructor"
          ~time:0.
          Junit.Testcase.Skipped;
        Junit.Testcase.make
          ~name:"should default useDotNotation to true"
          ~classname:"JUnitXmlReporter.constructor"
          ~time:0.
          Junit.Testcase.Pass;
      ]
    in
    Junit.Testsuite.make "JUnitXmlReporter.constructor"
    |> Junit.Testsuite.add_testcases testcases
    |> Junit.Testsuite.add_properties properties
  in
  let report = Junit.make [junitXmlReporter; junitXmlReportConstructor] in
  let xml_report = Junit.to_xml report in
  Tyxml.Xml.print_list print_string [xml_report]
