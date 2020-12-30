open! Core_kernel

type t [@@deriving sexp, compare, equal, yojson]

val of_string : string -> t

val to_string : t -> string

val timestamp : t -> Int64.t

val to_time : t -> Time.t
