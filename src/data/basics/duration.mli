open! Core_kernel

module Seconds : sig
  type t [@@deriving sexp, compare, equal, yojson]

  val to_int : t -> int

  val to_string : t -> string

  val of_int : int -> t

  val of_string : string -> t
end

module Days : sig
  type t [@@deriving sexp, compare, equal, yojson]

  val to_int : t -> int

  val to_string : t -> string

  val of_int : int -> t

  val of_string : string -> t
end
