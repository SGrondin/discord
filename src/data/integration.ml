open! Core_kernel
open! Basics

module Account = struct
  type t = {
    id: string;
    name: string;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Expire_behavior = struct
  module Self = struct
    type t =
      | Remove_role
      | Kick
      | Unknown     of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Application = struct
  type t = {
    id: Snowflake.t;
    name: string;
    icon: Image_hash.t option;
    description: string;
    summary: string;
    bot: User.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Self = struct
  type t = {
    id: Snowflake.t;
    name: string;
    type_: string; [@key "type"]
    enabled: bool;
    syncing: bool option; [@default None]
    role_id: Snowflake.t option; [@default None]
    enable_emoticons: bool option; [@default None]
    expire_behavior: Expire_behavior.t option; [@default None]
    expire_grace_period: Duration.Days.t option; [@default None]
    user: User.t option; [@default None]
    account: Account.t;
    synced_at: Timestamp.t option; [@default None]
    subscriber_count: int option; [@default None]
    revoked: bool option; [@default None]
    application: Application.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
