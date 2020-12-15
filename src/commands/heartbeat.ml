open! Core_kernel
open! Basics

module Self = struct
  type t = int option [@@deriving sexp, compare, equal, yojson { strict = false }]
end

include Self

let to_payload x =
  { Data.Payload.op = Data.Payload.Opcode.Heartbeat; t = None; s = None; d = Self.to_yojson x }

let%expect_test "Identify of yojson" =
  let test = Shared.test (module Self) in
  test {|123|};
  [%expect {| (123) |}]
