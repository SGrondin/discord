open! Core_kernel
open! Basics

module Opcode = struct
  module Self = struct
    type t =
      | Dispatch
      | Heartbeat
      | Identify
      | Presence_update
      | Voice_state_update
      | Deprecated_opcode_1
      | Resume
      | Reconnect
      | Request_guild_members
      | Invalid_session
      | Hello
      | Heartbeat_ACK
      | Unknown               of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    op: Opcode.t;
    t: string option; [@default None]
    s: int option; [@default None]
    d: Json.t; [@default `Assoc []]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

module type S = sig
  type t

  val to_payload : t -> Self.t
end
