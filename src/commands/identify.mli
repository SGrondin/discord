open! Core_kernel
open! Basics

module Connection_properties : sig
  type t = {
    os: string;
    browser: string;
    device: string;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Intent : sig
  type t =
    | GUILDS
    | GUILD_MEMBERS
    | GUILD_BANS
    | GUILD_EMOJIS
    | GUILD_INTEGRATIONS
    | GUILD_WEBHOOKS
    | GUILD_INVITES
    | GUILD_VOICE_STATES
    | GUILD_PRESENCES
    | GUILD_MESSAGES
    | GUILD_MESSAGE_REACTIONS
    | GUILD_MESSAGE_TYPING
    | DIRECT_MESSAGES
    | DIRECT_MESSAGE_REACTIONS
    | DIRECT_MESSAGE_TYPING

  include Shared.S_Bitfield with type t := t
end

module Intents : Bitfield.S with type Elt.t := Intent.t

type t = {
  token: string;
  properties: Connection_properties.t;
  compress: bool option;
  large_threshold: int option;
  shard: Data.Sharding.t option;
  presence: Status_update.t option;
  guild_subscriptions: bool option;
  intents: Intents.t;
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
