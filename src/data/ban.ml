open! Core_kernel
open! Basics

module Self = struct
  type t = {
    reason: string option;
    user: User.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Ban of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "reason": "mentioning b1nzy",
  "user": {
    "username": "Mason",
    "discriminator": "9999",
    "id": "53908099506183680",
    "avatar": "a_bab14f271d565501444b2ca3be944b25"
  }
}
  |};
  [%expect
    {|
    ((reason ("mentioning b1nzy"))
     (user
      ((id 53908099506183680) (username Mason) (discriminator 9999)
       (avatar (a_bab14f271d565501444b2ca3be944b25)) (bot ()) (system ())
       (mfa_enabled ()) (locale ()) (verified ()) (email ()) (flags ())
       (premium_type ()) (public_flags ()) (member ())))) |}]
