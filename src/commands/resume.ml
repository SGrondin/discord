open! Core_kernel
open! Basics

module Self = struct
  type t = {
    token: string;
    session_id: string;
    seq: int option;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let to_payload x =
  { Data.Payload.op = Data.Payload.Opcode.Resume; t = None; s = None; d = Self.to_yojson x }

let%expect_test "Identify of yojson" =
  let test = Shared.test (module Self) in
  test {|
{
  "token": "randomstring",
  "session_id": "evenmorerandomstring",
  "seq": 1337
}
  |};
  [%expect {| ((token randomstring) (session_id evenmorerandomstring) (seq (1337))) |}]
