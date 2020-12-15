open! Core_kernel
open! Basics

module Self = struct
  type t = {
    guild_id: Snowflake.t;
    channel_id: Snowflake.t option;
    self_mute: bool;
    self_deaf: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let to_payload x =
  { Data.Payload.op = Data.Payload.Opcode.Voice_state_update; t = None; s = None; d = Self.to_yojson x }

let%expect_test "voice state update of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "guild_id": "41771983423143937",
  "channel_id": "127121515262115840",
  "self_mute": false,
  "self_deaf": false
}
  |};
  [%expect
    {|
    ((guild_id 41771983423143937) (channel_id (127121515262115840))
     (self_mute false) (self_deaf false)) |}]
