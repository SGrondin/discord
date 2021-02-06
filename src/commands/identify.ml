open! Core_kernel
open! Basics

module Connection_properties = struct
  type t = {
    os: string; [@key "$os"]
    browser: string; [@key "$browser"]
    device: string; [@key "$device"]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Intent = struct
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
  [@@deriving sexp, compare, equal, enum]

  let here = [%here]
end

module Intents = Basics.Bitfield.Make (Intent)

module Self = struct
  type t = {
    token: string;
    properties: Connection_properties.t;
    compress: bool option; [@default Some false]
    large_threshold: int option; [@default Some 50]
    shard: Data.Sharding.t option; [@default None]
    presence: Status_update.t option; [@default None]
    guild_subscriptions: bool option; [@default Some true]
    intents: Intents.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let to_payload x =
  { Data.Payload.op = Data.Payload.Opcode.Identify; t = None; s = None; d = Self.to_yojson x }

let%expect_test "Identify of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "token": "my_token",
  "intents": 513,
  "properties": {
    "$os": "linux",
    "$browser": "disco",
    "$device": "disco"
  },
  "compress": true,
  "large_threshold": 250,
  "guild_subscriptions": false,
  "shard": [0, 1],
  "presence": {
    "activities": [{
      "name": "Cards Against Humanity",
      "type": 0,
      "created_at": 123
    }],
    "status": "dnd",
    "since": 91879201,
    "afk": false
  },
  "intents": 7
}
  |};
  [%expect
    {|
    ((token my_token) (properties ((os linux) (browser disco) (device disco)))
     (compress (true)) (large_threshold (250))
     (shard (((shard_id 0) (num_shards 1))))
     (presence
      (((since (91879201))
        (activities
         ((((id ()) (name "Cards Against Humanity") (type_ Game) (url ())
            (created_at 123) (timestamps ()) (sync_id ()) (platform ())
            (application_id ()) (details ()) (state ()) (emoji ())
            (session_id ()) (party ()) (assets ()) (secrets ()) (instance ())
            (flags ())))))
        (status DND) (afk false))))
     (guild_subscriptions (false)) (intents (GUILDS GUILD_MEMBERS GUILD_BANS))) |}]

let%expect_test "Intent bitfield to int" =
  let test x = [%to_yojson: Intents.t] x |> Yojson.Safe.to_string |> print_endline in

  test [ GUILD_MEMBERS; GUILD_MESSAGES ];
  [%expect {| 514 |}];
  test [ GUILD_MEMBERS; GUILD_MESSAGES; GUILD_MEMBERS ];
  [%expect {| 514 |}];
  test [ GUILD_MEMBERS; GUILD_MESSAGES; GUILD_VOICE_STATES ];
  [%expect {| 642 |}]

let%expect_test "Login bitfield of int" =
  let test x =
    [%of_yojson: Intents.t] x |> Result.ok_or_failwith |> sprintf !"%{sexp: Intents.t}" |> print_endline
  in
  test (`Int 514);
  [%expect {| (GUILD_MEMBERS GUILD_MESSAGES) |}];
  test (`Int 642);
  [%expect {| (GUILD_MEMBERS GUILD_VOICE_STATES GUILD_MESSAGES) |}]
