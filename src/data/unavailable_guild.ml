open! Core_kernel
open! Basics

module Self = struct
  type t = { id: Snowflake.t }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }] [@@unboxed]
end

include Self

let%expect_test "Unavailable guild of yojson" =
  let test = Shared.test (module Self) in
  test {|
{
  "id": "41771983423143937",
  "unavailable": true
}
  |};
  [%expect {| ((id 41771983423143937)) |}]
