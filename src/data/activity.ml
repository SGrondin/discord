open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | Game
      | Streaming
      | Listening
      | Custom
      | Competing
      | Unknown   of int
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_Int (Self)
end

module Timestamps = struct
  type t = {
    start: Int64.t option; [@default None]
    end_: Int64.t option; [@default None] [@key "end"]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Emoji = struct
  type t = {
    name: string;
    id: Snowflake.t option; [@default None]
    animated: bool option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Party_size = struct
  type t = {
    current_size: int;
    max_size: int;
  }
  [@@deriving sexp, compare, equal, fields]

  let to_yojson { current_size; max_size } = `List [ `Int current_size; `Int max_size ]

  let of_yojson = function
  | `List [ `Int current_size; `Int max_size ] -> Ok { current_size; max_size }
  | json -> Shared.invalid json "party size"
end

module Party = struct
  type t = {
    id: string;
    size: Party_size.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Asset = struct
  type t = {
    large_image: string option; [@default None]
    large_text: string option; [@default None]
    small_image: string option; [@default None]
    small_text: string option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Secret = struct
  type t = {
    join: string option; [@default None]
    spectate: string option; [@default None]
    match_: string option; [@default None] [@key "match"]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Flag = struct
  type t =
    | INSTANCE
    | JOIN
    | SPECTATE
    | JOIN_REQUEST
    | SYNC
    | PLAY
  [@@deriving sexp, compare, equal, enum]

  let here = [%here]
end

module Flags = Bitfield.Make (Flag)

module Self = struct
  type t = {
    id: string option; [@default None]
    name: string;
    type_: Type.t; [@key "type"]
    url: Url.t option; [@default None]
    (* TODO *)
    created_at: Int64.t;
    timestamps: Timestamps.t option; [@default None]
    sync_id: string option; [@default None]
    platform: string option; [@default None]
    application_id: Snowflake.t option; [@default None]
    details: string option; [@default None]
    state: string option; [@default None]
    emoji: Emoji.t option; [@default None]
    session_id: string option; [@default None]
    party: Party.t option; [@default None]
    assets: Asset.t option; [@default None]
    secrets: Secret.t option; [@default None]
    instance: bool option; [@default None]
    flags: Flags.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Party to yojson" =
  let test p = Party.to_yojson p |> Yojson.Safe.to_string |> print_endline in
  test { id = "foo"; size = { current_size = 3; max_size = 5 } };
  [%expect {| {"id":"foo","size":[3,5]} |}]

let%expect_test "Party of yojson" =
  let test s =
    Yojson.Safe.from_string s
    |> Party.of_yojson
    |> Result.ok_or_failwith
    |> [%sexp_of: Party.t]
    |> Sexp.to_string
    |> print_endline
  in
  test {|{"id":"foo","size":[4,12]}|};
  [%expect {| ((id foo)(size((current_size 4)(max_size 12)))) |}]

let%expect_test "Activity of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "name": "Rocket League",
  "type": 0,
  "application_id": "379286085710381999",
  "state": "In a Match",
  "details": "Ranked Duos: 2-1",
  "created_at": 15112000660000,
  "timestamps": {
    "start": 15112000660000
  },
  "party": {
    "id": "9dd6594e-81b3-49f6-a6b5-a679e6a060d3",
    "size": [2, 2]
  },
  "assets": {
    "large_image": "351371005538729000",
    "large_text": "DFH Stadium",
    "small_image": "351371005538729111",
    "small_text": "Silver III"
  },
  "secrets": {
    "join": "025ed05c71f639de8bfaa0d679d7c94b2fdce12f",
    "spectate": "e7eb30d2ee025ed05c71ea495f770b76454ee4e0",
    "match": "4b2fdce12f639de8bfa7e3591b71a0d679d7c93f"
  }
}
  |};
  [%expect
    {|
      ((id ()) (name "Rocket League") (type_ Game) (url ())
       (created_at 15112000660000)
       (timestamps (((start (15112000660000)) (end_ ())))) (sync_id ())
       (platform ()) (application_id (379286085710381999))
       (details ("Ranked Duos: 2-1")) (state ("In a Match")) (emoji ())
       (session_id ())
       (party
        (((id 9dd6594e-81b3-49f6-a6b5-a679e6a060d3)
          (size ((current_size 2) (max_size 2))))))
       (assets
        (((large_image (351371005538729000)) (large_text ("DFH Stadium"))
          (small_image (351371005538729111)) (small_text ("Silver III")))))
       (secrets
        (((join (025ed05c71f639de8bfaa0d679d7c94b2fdce12f))
          (spectate (e7eb30d2ee025ed05c71ea495f770b76454ee4e0))
          (match_ (4b2fdce12f639de8bfa7e3591b71a0d679d7c93f)))))
       (instance ()) (flags ())) |}]
