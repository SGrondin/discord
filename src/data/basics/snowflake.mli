open! Core_kernel

type t [@@deriving sexp, compare, equal, yojson]

module Set : Set.S with type Elt.t = t

module Map : Map.S with type Key.t = t

val of_string : string -> t

val to_string : t -> string

val timestamp : t -> Int64.t

val to_time : t -> Time.t
