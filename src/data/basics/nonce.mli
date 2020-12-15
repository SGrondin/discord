open! Core_kernel

type t =
  | N_String of string
  | N_Int    of int
[@@deriving sexp, compare, equal, yojson]
