open! Core_kernel

module type S = sig
  type t [@@deriving sexp, compare, equal, yojson]
end

module Make : functor (X : Shared.S_Bitfield) -> S with type t = X.t list
