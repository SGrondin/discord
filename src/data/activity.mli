open! Core_kernel
open! Basics

module Type : sig
  type t =
    | Game
    | Streaming
    | Listening
    | Custom
    | Competing
    | Unknown   of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Timestamps : sig
  type t = {
    start: Int64.t option;
    end_: Int64.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Emoji : sig
  type t = {
    name: string;
    id: Snowflake.t option;
    animated: bool option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Party_size : sig
  type t = {
    current_size: int;
    max_size: int;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Party : sig
  type t = {
    id: string;
    size: Party_size.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Asset : sig
  type t = {
    large_image: string option;
    large_text: string option;
    small_image: string option;
    small_text: string option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Secret : sig
  type t = {
    join: string option;
    spectate: string option;
    match_: string option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Flag : sig
  type t =
    | INSTANCE
    | JOIN
    | SPECTATE
    | JOIN_REQUEST
    | SYNC
    | PLAY

  include Shared.S_Bitfield with type t := t
end

module Flags : Bitfield.S with type elt := Flag.t

type t = {
  id: string option;
  name: string;
  type_: Type.t;
  url: Url.t option;
  created_at: Int64.t;
  timestamps: Timestamps.t option;
  sync_id: string option;
  platform: string option;
  application_id: Snowflake.t option;
  details: string option;
  state: string option;
  emoji: Emoji.t option;
  session_id: string option;
  party: Party.t option;
  assets: Asset.t option;
  secrets: Secret.t option;
  instance: bool option;
  flags: Flags.t option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
