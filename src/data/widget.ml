open! Core_kernel
open! Basics

module Widget = struct
  type t = {
    enabled: bool;
    channel_id: Snowflake.t option;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Widget

let%expect_test "Widget of yojson" =
  let test = Shared.test (module Widget) in
  test {|
{
  "enabled": true,
  "channel_id": "41771983444115456"
}
  |};
  [%expect {| ((enabled true) (channel_id (41771983444115456))) |}]
