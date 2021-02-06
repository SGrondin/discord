open! Core_kernel

module Seconds = struct
  type t = Time.Span.t [@@deriving sexp, compare, equal]

  let to_int d = Time.Span.to_sec d |> Float.iround_nearest_exn

  let to_string = Time.Span.to_string

  let to_yojson d = `Int (to_int d)

  let of_int x = Time.Span.create ~sec:x ()

  let of_string s = Int.of_string s |> of_int

  let of_yojson = function
  | `Int x -> Ok (Time.Span.create ~sec:x ())
  | json -> Shared.invalid json "number of seconds"
end

let%expect_test "Seconds duration to string" =
  let test d = Seconds.to_string d |> print_endline in
  test (Seconds.of_int 333);
  [%expect {| 5m33s |}];
  test (Time.Span.create ~sec:333 ~ms:630 ());
  [%expect {| 5m33.63s |}]

let%expect_test "Seconds duration to yojson" =
  let test d = Seconds.to_yojson d |> Yojson.Safe.to_string |> print_endline in
  test (Time.Span.create ~sec:333 ());
  [%expect {| 333 |}];
  test (Time.Span.create ~sec:333 ~ms:630 ());
  [%expect {| 334 |}]

let%expect_test "Seconds duration of yojson" =
  let test s =
    Yojson.Safe.from_string s
    |> Seconds.of_yojson
    |> Result.ok_or_failwith
    |> sprintf !"%{sexp: Seconds.t}"
    |> print_endline
  in
  test {|55|};
  [%expect {| 55s |}];
  test {|333|};
  [%expect {| 5m33s |}]

module Days = struct
  type t = Time.Span.t [@@deriving sexp, compare, equal]

  let to_int d = Time.Span.to_day d |> Float.iround_nearest_exn

  let to_string = Time.Span.to_string

  let to_yojson d = `Int (to_int d)

  let of_int x = Time.Span.create ~day:x ()

  let of_string s = Int.of_string s |> of_int

  let of_yojson = function
  | `Int x -> Ok (Time.Span.create ~day:x ())
  | json -> Shared.invalid json "number of days"
end

let%expect_test "Days duration to string" =
  let test d = Days.to_string d |> print_endline in
  test (Days.of_int 333);
  [%expect {| 333d |}];
  test (Time.Span.create ~day:333 ~hr:15 ());
  [%expect {| 333d15h |}]

let%expect_test "Days duration to yojson" =
  let test d = Days.to_yojson d |> Yojson.Safe.to_string |> print_endline in
  test (Time.Span.create ~day:333 ());
  [%expect {| 333 |}];
  test (Time.Span.create ~day:333 ~hr:15 ());
  [%expect {| 334 |}]

let%expect_test "Days duration of yojson" =
  let test s =
    Yojson.Safe.from_string s
    |> Days.of_yojson
    |> Result.ok_or_failwith
    |> sprintf !"%{sexp: Days.t}"
    |> print_endline
  in
  test {|55|};
  [%expect {| 55d |}];
  test {|333|};
  [%expect {| 333d |}]
