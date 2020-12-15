open! Core_kernel
open! Basics

module User_ids : sig
  type t = Snowflake.t list

  include Shared.S_Base with type t := t
end

type t = {
  guild_id: Snowflake.t;
  query: string option; [@default None]
  limit: int;
  presences: bool option; [@default None]
  user_ids: User_ids.t option; [@default None]
  nonce: string option; [@default None]
}
[@@deriving fields]

include Shared.S_Object with type t := t

include Data.Payload.S with type t := t
