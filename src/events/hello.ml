open! Core_kernel
open! Basics

module Self = struct
  type t = { heartbeat_interval: int }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }] [@@unboxed]
end

include Self

let%expect_test "Hello of yojson" =
  let test = Shared.test (module Self) in
  test {|
{
  "heartbeat_interval": 45000
}
  |};
  [%expect {| ((heartbeat_interval 45000)) |}]
