open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | Deprecated_type_1
      | Incoming
      | Channel_follower
      | Unknown           of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Self = struct
  type t = {
    id: Snowflake.t;
    type_: Type.t; [@key "type"]
    guild_id: Snowflake.t option; [@default None]
    channel_id: Snowflake.t;
    user: User.t option; [@default None]
    name: string option;
    avatar: string option;
    token: string option; [@default None]
    (* According to the docs it is "application_id: ?string" but it seems to be "application_id?: ?string" *)
    (* See https://github.com/discord/discord-api-docs/issues/2284 *)
    application_id: Snowflake.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Webhook of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "name": "test webhook",
  "type": 1,
  "channel_id": "199737254929760256",
  "token": "3d89bb7572e0fb30d8128367b3b1b44fecd1726de135cbe28a41f8b2f777c372ba2939e72279b94526ff5d1bd4358d65cf11",
  "avatar": null,
  "guild_id": "199737254929760256",
  "id": "223704706495545344",
  "user": {
    "username": "test",
    "discriminator": "7479",
    "id": "190320984123768832",
    "avatar": "b004ec1740a63ca06ae2e14c5cee11f3"
  }
}
  |};
  [%expect
    {|
      ((id 223704706495545344) (type_ Incoming) (guild_id (199737254929760256))
       (channel_id 199737254929760256)
       (user
        (((id 190320984123768832) (username test) (discriminator 7479)
          (avatar (b004ec1740a63ca06ae2e14c5cee11f3)) (bot ()) (system ())
          (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
          (premium_type ()) (public_flags ()) (member ()))))
       (name ("test webhook")) (avatar ())
       (token
        (3d89bb7572e0fb30d8128367b3b1b44fecd1726de135cbe28a41f8b2f777c372ba2939e72279b94526ff5d1bd4358d65cf11))
       (application_id ())) |}]
