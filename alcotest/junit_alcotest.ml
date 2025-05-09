module A = Alcotest

external reraise : exn -> 'a = "%reraise"

type exit = unit -> unit

let push l v = l := v :: !l

let wrap_test ?classname handle_result (name, s, test) =
  let classname =
    (* The 'classname' attribute may not be empty, and should contain a period
       for best rendering in Jenkins by junit-plugin.
       For example, classname="foo.bar.baz" is rendered as a package "foo.bar"
       containing a class "baz" containing one or more test cases with their
       own name. *)
    match classname with
    | None | Some "" -> name
    | Some path -> path
  in
  let test () =
    try
      test ();
      Junit.Testcase.pass ~name ~classname ~time:0. |> handle_result
    with
    | Failure exn_msg as exn ->
      Junit.Testcase.failure
        ~name
        ~classname
        ~time:0.
        ~typ:"not expected result"
        ~message:"test failed"
        exn_msg
      |> handle_result;
      reraise exn
    | Alcotest_engine.V1.Core.Skip as exn ->
      Junit.Testcase.skipped ~name ~classname ~time:0. |> handle_result;
      reraise exn
    | exn ->
      let exn_msg = Printexc.to_string exn in
      Junit.Testcase.error
        ~name
        ~classname
        ~time:0.
        ~typ:"exception raised"
        ~message:"test crashed"
        exn_msg
      |> handle_result;
      reraise exn
  in
  name, s, test
;;

let run_and_report
      ?stdout
      ?stderr
      ?(and_exit = true)
      ?verbose
      ?compact
      ?tail_errors
      ?quick_only
      ?show_errors
      ?json
      ?filter
      ?log_dir
      ?bail
      ?record_backtrace
      ?ci
      ?package
      ?timestamp
      ?argv
      name
      tests
  =
  let testcases = ref [] in
  let testsuite = Junit.Testsuite.make ?package ?timestamp ~name () in
  let tests =
    List.map
      (fun (title, test_set) ->
         let classname = Printf.sprintf "%s.%s" name title in
         title, List.map (wrap_test ~classname (push testcases)) test_set)
      tests
  in
  let exit =
    try
      A.run
        ?stdout
        ?stderr
        ?verbose
        ?compact
        ?tail_errors
        ?quick_only
        ?show_errors
        ?json
        ?filter
        ?log_dir
        ?bail
        ?record_backtrace
        ?ci
        ?argv
        ~and_exit:false
        name
        tests;
      fun () -> if and_exit then exit 0 else ()
    with
    | A.Test_error as exn -> fun () -> if and_exit then exit 1 else reraise exn
  in
  Junit.Testsuite.add_testcases !testcases testsuite, exit
;;
