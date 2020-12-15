open! Core_kernel
open! Basics

module Opcode : sig
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
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Self : sig
  type t = {
    op: Opcode.t;
    t: string option;
    s: int option;
    d: Json.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

include module type of Self with type t = Self.t

module type S = sig
  type t

  val to_payload : t -> Self.t
end
