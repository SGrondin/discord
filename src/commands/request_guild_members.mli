open! Core_kernel
open! Basics

module User_ids : sig
  type t = Snowflake.t list

  include Shared.S_Base with type t := t
end

type t = {
  guild_id: Snowflake.t;
  query: string option;
  limit: int;
  presences: bool option;
  user_ids: User_ids.t option;
  nonce: string option;
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
