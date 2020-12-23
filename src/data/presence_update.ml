open! Core_kernel
open! Basics

module Status = struct
  module Self = struct
    type t =
      | Idle [@name "idle"]
      | DND [@name "dnd"]
      | Online [@name "online"]
      | Offline [@name "offline"]
      | Invisible [@name "invisible"]
      | Unknown   of string
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_String (Self)
end

module Client_status = struct
  type t = {
    desktop: Status.t option; [@default None]
    mobile: Status.t option; [@default None]
    web: Status.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

let user_id_of_yojson : Yojson.Safe.t -> (Snowflake.t, string) result = function
| `Assoc ll as json -> (
  match List.Assoc.find ll ~equal:String.equal "id" with
  | Some x -> Snowflake.of_yojson x
  | None -> Shared.invalid json "presence update user id"
)
| json -> Shared.invalid json "presence update user id"

let user_id_to_yojson x : Yojson.Safe.t = `Assoc [ "id", Snowflake.to_yojson x ]

module Self = struct
  type t = {
    user_id: Snowflake.t; [@key "user"] [@of_yojson user_id_of_yojson] [@to_yojson user_id_to_yojson]
    guild_id: Snowflake.t option; [@default None]
    status: Status.t;
    activities: Activity.t list;
    client_status: Client_status.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
