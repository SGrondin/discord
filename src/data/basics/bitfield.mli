open! Core_kernel

module type S = sig
  type elt

  module Set : Set.S with type Elt.t := elt

  type t = Set.t [@@deriving sexp, compare, equal, yojson]
end

module Make : functor (M : Shared.S_Bitfield) -> S with type elt := M.t
