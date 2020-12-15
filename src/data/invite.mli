open! Core_kernel
open! Basics

module Metadata : sig
  type t = {
    uses: int;
    max_uses: int;
    max_age: Duration.Seconds.t;
    temporary: bool;
    created_at: Timestamp.t;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Target_user_type : sig
  type t =
    | Deprecated_type_1
    | STREAM
    | Unknown           of int
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

type t = {
  code: string;
  guild: Guild.t option;
  channel: Channel.t;
  inviter: User.t option;
  target_user: User.t option;
  target_user_type: Target_user_type.t option;
  approximate_presence_count: int option;
  approximate_member_count: int option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
