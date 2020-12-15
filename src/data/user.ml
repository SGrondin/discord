open! Core_kernel
open! Basics

module Flag = struct
  type t =
    | Discord_employee
    | Partnered_server_owner
    | Hypesquad_events
    | Bug_hunter_level_1
    | Deprecated_flag_4
    | Deprecated_flag_5
    | House_bravery
    | House_brilliance
    | House_balance
    | Early_supporter
    | Team_user
    | Deprecated_flag_11
    | System
    | Deprecated_flag_13
    | Bug_hunter_level_2
    | Deprecated_flag_15
    | Verified_bot
    | Early_verified_bot_developer
  [@@deriving sexp, compare, equal, enum]

  let here = [%here]
end

module Flags = Bitfield.Make (Flag)

module Premium = struct
  module Self = struct
    type t =
      | None_
      | Nitro_classic
      | Nitro
      | Unknown       of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type member = {
    user: t option; [@default None]
    nick: string option; [@default None]
    roles: Snowflake.t list;
    joined_at: Timestamp.t;
    premium_since: Timestamp.t option; [@default None]
    deaf: bool;
    mute: bool;
  }

  and t = {
    id: Snowflake.t;
    username: string;
    discriminator: string;
    avatar: Image_hash.t option;
    bot: bool option; [@default None]
    system: bool option; [@default None]
    mfa_enabled: bool option; [@default None]
    locale: string option; [@default None]
    verified: bool option; [@default None]
    email: string option; [@default None]
    flags: Flags.t option; [@default None]
    premium_type: Premium.t option; [@default None]
    public_flags: Flags.t option; [@default None]
    member: member option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]

  module Util = struct
    let is_bot member_opt =
      Option.Monad_infix.(member_opt >>= user >>= bot) |> Option.value ~default:false

    let member_id = function
    | { user = Some { id; _ }; _ } -> Some id
    | _ -> None

    let member_name = function
    | { nick = Some username; _ }
     |{ user = Some { username; _ }; _ } ->
      Some username
    | _ -> None
  end
end

include Self

let%expect_test "User of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "80351110224678912",
  "username": "Nelly",
  "discriminator": "1337",
  "avatar": "8342729096ea3675442027381ff50dfe",
  "verified": true,
  "email": "nelly@discord.com",
  "flags": 64,
  "premium_type": 1,
  "public_flags": 64
}
  |};
  [%expect
    {|
    ((id 80351110224678912) (username Nelly) (discriminator 1337)
     (avatar (8342729096ea3675442027381ff50dfe)) (bot ()) (system ())
     (mfa_enabled ()) (locale ()) (verified (true)) (email (nelly@discord.com))
     (flags ((House_bravery))) (premium_type (Nitro_classic))
     (public_flags ((House_bravery))) (member ())) |}]

let%expect_test "Member of yojson" =
  let test =
    Shared.test
      ( module struct
        type t = member [@@deriving sexp, compare, equal, yojson]
      end
      )
  in
  test
    {|
{
  "nick": "NOT API SUPPORT",
  "roles": [],
  "joined_at": "2015-04-26T06:26:56.936000+00:00",
  "deaf": false,
  "mute": false
}
  |};
  [%expect
    {|
    ((user ()) (nick ("NOT API SUPPORT")) (roles ())
     (joined_at "2015-04-26 06:26:56.936000Z") (premium_since ()) (deaf false)
     (mute false)) |}]
