open! Core_kernel

include module type of Yojson.Safe

module Map : Map.S with type Key.t := Yojson.Safe.t

val sexp_of_t : [%sexp_of: t]

val t_of_sexp : [%of_sexp: t]

val compare : [%compare: t]

val equal : [%equal: t]

val to_yojson : t -> Yojson.Safe.t

val of_yojson : Yojson.Safe.t -> (t, string) result
