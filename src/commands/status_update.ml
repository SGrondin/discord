open! Core_kernel
open! Basics

module Self = struct
  type t = {
    (* TODO *)
    since: Int64.t option;
    activities: Data.Activity.t list option;
    status: Data.Presence_update.Status.t;
    afk: bool;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self

let to_payload x =
  { Data.Payload.op = Data.Payload.Opcode.Presence_update; t = None; s = None; d = Self.to_yojson x }

let%expect_test "Status update of yojson" =
  let test = Shared.test (module Self) in
  test
    {|
{
  "since": 91879201,
  "activities": [{
    "name": "Save the Oxford Comma",
    "type": 0,
    "created_at": 123
  }],
  "status": "online",
  "afk": false
}
  |};
  [%expect
    {|
    ((since (91879201))
     (activities
      ((((id ()) (name "Save the Oxford Comma") (type_ Game) (url ())
         (created_at 123) (timestamps ()) (sync_id ()) (platform ())
         (application_id ()) (details ()) (state ()) (emoji ()) (session_id ())
         (party ()) (assets ()) (secrets ()) (instance ()) (flags ())))))
     (status Online) (afk false)) |}]
