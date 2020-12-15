open! Core_kernel
open! Basics

module User_ids = struct
  type t = Snowflake.t list [@@deriving sexp, compare, equal]

  let to_yojson = function
  | [ x ] -> [%to_yojson: Snowflake.t] x
  | ll -> [%to_yojson: Snowflake.t list] ll

  let of_yojson = function
  | `String _ as x -> [%of_yojson: Snowflake.t] x |> Result.map ~f:List.return
  | `List _ as ll -> [%of_yojson: Snowflake.t list] ll
  | json -> Shared.invalid json "request guild members user ids"
end

module Self = struct
  type t = {
    guild_id: Snowflake.t;
    query: string option; [@default None]
    limit: int;
    presences: bool option; [@default None]
    user_ids: User_ids.t option; [@default None]
    nonce: string option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let to_payload x =
  {
    Data.Payload.op = Data.Payload.Opcode.Request_guild_members;
    t = None;
    s = None;
    d = Self.to_yojson x;
  }

let%expect_test "Request guild members of yojson" =
  let test = Shared.test (module Self) in
  test {|
{
  "guild_id": "41771983444115456",
  "query": "",
  "limit": 0
}
  |};
  [%expect
    {|
    ((guild_id 41771983444115456) (query ("")) (limit 0) (presences ())
     (user_ids ()) (nonce ())) |}];
  test
    {|
{
  "guild_id": "41771983444115456",
  "query": "",
  "limit": 0,
  "user_ids": "47399393948472693"
}
  |};
  [%expect
    {|
    ((guild_id 41771983444115456) (query ("")) (limit 0) (presences ())
     (user_ids ((47399393948472693))) (nonce ())) |}];
  test
    {|
{
  "guild_id": "41771983444115456",
  "query": "",
  "limit": 0,
  "user_ids": ["47399393948472693", "47399393948472699"]
}
  |};
  [%expect
    {|
    ((guild_id 41771983444115456) (query ("")) (limit 0) (presences ())
     (user_ids ((47399393948472693 47399393948472699))) (nonce ())) |}]
