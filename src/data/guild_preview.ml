open! Core_kernel
open! Basics

module Self = struct
  type t = {
    id: Snowflake.t;
    name: string;
    icon: Image_hash.t option;
    splash: Image_hash.t option;
    discovery_splash: Image_hash.t option;
    emojis: Emoji.t list;
    features: Guild.Feature.t list;
    approximate_member_count: int;
    approximate_presence_count: int;
    description: string option;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Guild preview of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "id": "197038439483310086",
  "name": "Discord Testers",
  "icon": "f64c482b807da4f539cff778d174971c",
  "splash": null,
  "discovery_splash": null,
  "emojis": [],
  "features": [
    "DISCOVERABLE",
    "VANITY_URL",
    "ANIMATED_ICON",
    "INVITE_SPLASH",
    "NEWS",
    "COMMUNITY",
    "BANNER",
    "VERIFIED",
    "MORE_EMOJI"
  ],
  "approximate_member_count": 60814,
  "approximate_presence_count": 20034,
  "description": "The official place to report Discord Bugs!"
}
  |};
  [%expect
    {|
      ((id 197038439483310086) (name "Discord Testers")
       (icon (f64c482b807da4f539cff778d174971c)) (splash ()) (discovery_splash ())
       (emojis ())
       (features
        (DISCOVERABLE VANITY_URL ANIMATED_ICON INVITE_SPLASH NEWS COMMUNITY BANNER
         VERIFIED (Unknown MORE_EMOJI)))
       (approximate_member_count 60814) (approximate_presence_count 20034)
       (description ("The official place to report Discord Bugs!"))) |}]
