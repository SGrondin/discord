open! Core_kernel

module type S = sig
  include Set.S

  val to_yojson : t -> Yojson.Safe.t

  val of_yojson : Yojson.Safe.t -> (t, string) result
end

module Make : functor (M : Shared.S_Bitfield) -> S with type Elt.t := M.t
