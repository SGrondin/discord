open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | Roles [@name "roles"]
      | Users [@name "users"]
      | Everyone [@name "everyone"]
      | Unknown  of string
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_String (Self)
end

module Self = struct
  type t = {
    parse: Type.t list;
    roles: Snowflake.t list;
    users: Snowflake.t list;
    replied_user: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let%expect_test "Allowed mention to yojson" =
  let test x = Self.to_yojson x |> Yojson.Safe.pretty_to_string |> print_endline in
  test
    {
      parse = [ Roles; Users; Everyone; Unknown "SOMETHING_ELSE" ];
      roles = [];
      users = [];
      replied_user = true;
    };
  [%expect
    {|
    {
      "parse": [ "roles", "users", "everyone", SOMETHING_ELSE ],
      "roles": [],
      "users": [],
      "replied_user": true
    }|}]
