open! Core_kernel

type custom_emoji = {
  id: Snowflake.t;
  name: string;
  animated: bool;
}
[@@deriving sexp, yojson]

type emoji =
  [ `Unicode_emoji of string
  | `Custom_emoji  of custom_emoji
  ]
[@@deriving sexp, yojson]

type t =
  [ emoji
  | `User of Snowflake.t
  | `User_nickname of Snowflake.t
  | `Channel of Snowflake.t
  | `Role of Snowflake.t
  ]
[@@deriving sexp, yojson]

let ss = Snowflake.to_string

let to_string = function
| `User x -> sprintf "<@%s>" (ss x)
| `User_nickname x -> sprintf "<@!%s>" (ss x)
| `Channel x -> sprintf "<#%s>" (ss x)
| `Role x -> sprintf "<@&%s>" (ss x)
| `Unicode_emoji x -> x
| `Custom_emoji { animated = false; name; id } -> sprintf "<:%s:%s>" name (ss id)
| `Custom_emoji { animated = true; name; id } -> sprintf "<a:%s:%s>" name (ss id)

let to_url r =
  begin
    match r with
    | `Unicode_emoji x -> x
    | `Custom_emoji { animated = false; name; id } -> sprintf ":%s:%s" name (ss id)
    | `Custom_emoji { animated = true; name; id } -> sprintf "a:%s:%s" name (ss id)
  end
  |> Uri.pct_encode

let%expect_test "Reference to yojson" =
  let test x = [%to_yojson: t] x |> Yojson.Safe.pretty_to_string |> print_endline in
  test (`Unicode_emoji "✨");
  [%expect {| [ "Unicode_emoji", "✨" ] |}];
  test (`Custom_emoji { id = Snowflake.of_string "12345"; name = "derp"; animated = false });
  [%expect {| [ "Custom_emoji", { "id": "12345", "name": "derp", "animated": false } ] |}]
