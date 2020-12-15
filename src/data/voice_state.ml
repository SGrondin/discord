open! Core_kernel
open! Basics

module Self = struct
  type t = {
    guild_id: Snowflake.t option; [@default None]
    channel_id: Snowflake.t option;
    user_id: Snowflake.t;
    member: User.member option; [@default None]
    session_id: string;
    deaf: bool;
    mute: bool;
    self_deaf: bool;
    self_mute: bool;
    self_stream: bool option; [@default None]
    self_video: bool;
    suppress: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Voice state of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "channel_id": "157733188964188161",
  "user_id": "80351110224678912",
  "session_id": "90326bd25d71d39b9ef95b299e3872ff",
  "deaf": false,
  "mute": false,
  "self_deaf": false,
  "self_video": false,
  "self_stream": false,
  "self_mute": true,
  "suppress": false
}
  |};
  [%expect
    {|
    ((guild_id ()) (channel_id (157733188964188161)) (user_id 80351110224678912)
     (member ()) (session_id 90326bd25d71d39b9ef95b299e3872ff) (deaf false)
     (mute false) (self_deaf false) (self_mute true) (self_stream (false))
     (self_video false) (suppress false)) |}]
