open! Core_kernel
open! Basics

module Self = struct
  type t = {
    id: Snowflake.t option;
    name: string option;
    roles: Snowflake.t list option; [@default None]
    user: User.t option; [@default None]
    require_colons: bool option; [@default None]
    managed: bool option; [@default None]
    animated: bool option; [@default None]
    available: bool option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Emoji of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "41771983429993937",
  "name": "LUL",
  "roles": ["41771983429993000", "41771983429993111"],
  "user": {
    "username": "Luigi",
    "discriminator": "0002",
    "id": "96008815106887111",
    "avatar": "5500909a3274e1812beb4e8de6631111"
  },
  "require_colons": true,
  "managed": false,
  "animated": false
}
  |};
  [%expect
    {|
    ((id (41771983429993937)) (name (LUL))
     (roles ((41771983429993000 41771983429993111)))
     (user
      (((id 96008815106887111) (username Luigi) (discriminator 0002)
        (avatar (5500909a3274e1812beb4e8de6631111)) (bot ()) (system ())
        (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
        (premium_type ()) (public_flags ()) (member ()))))
     (require_colons (true)) (managed (false)) (animated (false)) (available ())) |}];
  test {|
{
  "id": null,
  "name": "🔥"
}
  |};
  [%expect
    {|
    ((id ()) (name ("\240\159\148\165")) (roles ()) (user ()) (require_colons ())
     (managed ()) (animated ()) (available ())) |}];
  test {|
{
  "id": "41771983429993937",
  "name": "LUL",
  "animated": true
}
  |};
  [%expect
    {|
    ((id (41771983429993937)) (name (LUL)) (roles ()) (user ())
     (require_colons ()) (managed ()) (animated (true)) (available ())) |}];
  test {|
{
  "id": "41771983429993937",
  "name": null
}
  |};
  [%expect
    {|
    ((id (41771983429993937)) (name ()) (roles ()) (user ()) (require_colons ())
     (managed ()) (animated ()) (available ())) |}]
