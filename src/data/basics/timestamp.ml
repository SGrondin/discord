open! Core_kernel

type t = Time.t [@@deriving compare, equal]

let to_string = Time.to_string

let of_string = Time.of_string

let sexp_of_t x = Sexp.Atom (to_string x)

let t_of_sexp = function
| Sexp.Atom s -> of_string s
| sexp -> failwithf "Impossible to convert S-Exp '%s' into a Time" (Sexp.to_string sexp) ()

let to_yojson x = `String (to_string x)

let of_yojson = function
| `String s -> Ok (of_string s)
| json -> Shared.invalid json "timestamp"

let%expect_test "Timestamp from yojson" =
  let test s = of_string s |> Time.to_string |> print_endline in
  test "2020-12-06T01:27:49.200000+00:00";
  [%expect {| 2020-12-06 01:27:49.200000Z |}]
