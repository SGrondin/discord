open! Core_kernel
open! Basics

module Metadata = struct
  type t = {
    uses: int;
    max_uses: int;
    max_age: Duration.Seconds.t;
    temporary: bool;
    created_at: Timestamp.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Target_user_type = struct
  module Self = struct
    type t =
      | Deprecated_type_1
      | STREAM
      | Unknown           of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    code: string;
    guild: Guild.t option; [@default None]
    channel: Channel.t;
    inviter: User.t option; [@default None]
    target_user: User.t option; [@default None]
    target_user_type: Target_user_type.t option; [@default None]
    approximate_presence_count: int option; [@default None]
    approximate_member_count: int option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Invite metadata of yojson" =
  let test = Shared.test (module Metadata) in
  test
    {|
{
  "uses": 0,
  "max_uses": 0,
  "max_age": 0,
  "temporary": false,
  "created_at": "2016-03-31T19:15:39.954000+00:00"
}
  |};
  [%expect
    {|
    ((uses 0) (max_uses 0) (max_age 0s) (temporary false)
     (created_at "2016-03-31 19:15:39.954000Z")) |}]

let%expect_test "Invite of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "code": "0vCdhLbwjZZTWZLD",
  "channel": {
    "id": "165176875973476352",
    "name": "illuminati",
    "type": 0
  },
  "inviter": {
    "id": "115590097100865541",
    "username": "speed",
    "avatar": "deadbeef",
    "discriminator": "7653"
  },
  "target_user": {
    "id": "165176875973476352",
    "username": "bob",
    "avatar": "deadbeef",
    "discriminator": "1234"
  },
  "target_user_type": 1
}
  |};
  [%expect
    {|
    ((code 0vCdhLbwjZZTWZLD) (guild ())
     (channel
      ((id 165176875973476352) (type_ GUILD_TEXT) (guild_id ()) (position ())
       (permission_overwrites ()) (name (illuminati)) (topic ()) (nsfw ())
       (last_message_id ()) (bitrate ()) (user_limit ()) (rate_limit_per_user ())
       (recipients ()) (icon ()) (owner_id ()) (application_id ()) (parent_id ())
       (last_pin_timestamp ())))
     (inviter
      (((id 115590097100865541) (username speed) (discriminator 7653)
        (avatar (deadbeef)) (bot ()) (system ()) (mfa_enabled ()) (locale ())
        (verified ()) (email ()) (flags ()) (premium_type ()) (public_flags ())
        (member ()))))
     (target_user
      (((id 165176875973476352) (username bob) (discriminator 1234)
        (avatar (deadbeef)) (bot ()) (system ()) (mfa_enabled ()) (locale ())
        (verified ()) (email ()) (flags ()) (premium_type ()) (public_flags ())
        (member ()))))
     (target_user_type (STREAM)) (approximate_presence_count ())
     (approximate_member_count ())) |}]
