open! Core_kernel

type t [@@deriving sexp, compare, equal, yojson]

val to_string : t -> string

val of_string : string -> t
