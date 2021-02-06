open! Core_kernel

module type S_Base = sig
  type t [@@deriving sexp, compare, equal, yojson]
end

module type S_Bitfield = sig
  type t [@@deriving sexp, compare, equal, enum]

  val here : Source_code_position.t
end

module type S_Enum = sig
  include S_Base

  val is_enum : unit
end

module type S_Object = sig
  include S_Base
end

let test m =
  let module M = (val m : S_Base) in
  fun s ->
    Yojson.Safe.from_string s
    |> M.of_yojson
    |> Result.ok_or_failwith
    |> sprintf !"%{sexp: M.t}"
    |> print_endline

let invalid json into = Error (sprintf !"Impossible to parse JSON '%{Yojson.Safe}' into: %s" json into)
