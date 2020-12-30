open! Core_kernel

type custom_emoji = {
  id: Snowflake.t;
  name: string;
  animated: bool;
}

type emoji =
  [ `Unicode_emoji of string
  | `Custom_emoji  of custom_emoji
  ]

type t =
  [ emoji
  | `User of Snowflake.t
  | `User_nickname of Snowflake.t
  | `Channel of Snowflake.t
  | `Role of Snowflake.t
  ]

let to_string = function
| `User x -> sprintf "<@%s>" (Snowflake.to_string x)
| `User_nickname x -> sprintf "<@!%s>" (Snowflake.to_string x)
| `Channel x -> sprintf "<#%s>" (Snowflake.to_string x)
| `Role x -> sprintf "<@&%s>" (Snowflake.to_string x)
| `Unicode_emoji x -> x
| `Custom_emoji { animated = false; name; id } -> sprintf "<:%s:%s>" name (Snowflake.to_string id)
| `Custom_emoji { animated = true; name; id } -> sprintf "<a:%s:%s>" name (Snowflake.to_string id)

let to_url r =
  begin
    match r with
    | `Unicode_emoji x -> x
    | `Custom_emoji { animated = false; name; id } -> sprintf ":%s:%s" name (Snowflake.to_string id)
    | `Custom_emoji { animated = true; name; id } -> sprintf "a:%s:%s" name (Snowflake.to_string id)
  end
  |> Uri.pct_encode
