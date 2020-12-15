open! Core_kernel

module type S = sig
  type t [@@deriving sexp, compare, equal, yojson]

  val to_int : t -> int

  val of_int : int -> t
end

module Make : functor (X : Shared.S_Bitfield) -> S with type t = X.t list
