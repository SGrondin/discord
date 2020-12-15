open! Core_kernel

type t =
  | N_String of string
  | N_Int    of int
[@@deriving sexp, compare, equal]

let of_yojson = function
| `String s -> Ok (N_String s)
| `Int x -> Ok (N_Int x)
| json -> Shared.invalid json "nonce"

let to_yojson = function
| N_String s -> `String s
| N_Int x -> `Int x
