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

module User_id = struct
  type t = { id: Snowflake.t } [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Self = struct
  type t = {
    user: User_id.t;
    guild_id: Snowflake.t option; [@default None]
    status: Status.t;
    activities: Activity.t list;
    client_status: Client_status.t;
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
