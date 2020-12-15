open! Core_kernel
open! Basics

module Self = struct
  type t = {
    id: Snowflake.t;
    name: string;
    color: int;
    hoist: bool;
    position: int;
    permissions: Permissions.t;
    managed: bool;
    mentionable: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Role of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "41771983423143936",
  "name": "WE DEM BOYZZ!!!!!!",
  "color": 3447003,
  "hoist": true,
  "position": 1,
  "permissions": "66321471",
  "managed": false,
  "mentionable": false
}
  |};
  [%expect
    {|
    ((id 41771983423143936) (name "WE DEM BOYZZ!!!!!!") (color 3447003)
     (hoist true) (position 1) (permissions 66321471) (managed false)
     (mentionable false)) |}]
