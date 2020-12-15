open! Core_kernel

include module type of Uri with type t = Uri.t

val t_of_sexp : Sexp.t -> t

val sexp_of_t : t -> Sexp.t

val to_yojson : t -> Yojson.Safe.t

val of_yojson : Yojson.Safe.t -> (t, string) result
