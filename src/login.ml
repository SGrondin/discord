open! Core_kernel

type t = {
  network_timeout: float;
  token: string;
  intents: Commands.Identify.Intents.t;
  activity: Data.Activity.t;
  status: Data.Presence_update.Status.t;
  afk: bool;
}
[@@deriving sexp, compare, equal, yojson]

let create ?(network_timeout = 1.0) ~token ~intents ?(activity_name = "Bot things")
   ?(activity_type = Data.Activity.Type.Game) ?(status = Data.Presence_update.Status.Online)
   ?(afk = false) () =
  let activity =
    Data.Activity.
      {
        id = None;
        name = activity_name;
        type_ = activity_type;
        url = None;
        created_at = Latch.Time.get ();
        timestamps = None;
        sync_id = None;
        platform = None;
        application_id = None;
        details = None;
        state = None;
        emoji = None;
        session_id = None;
        party = None;
        assets = None;
        secrets = None;
        instance = None;
        flags = None;
      }
  in
  { network_timeout; token; intents; activity; status; afk }
