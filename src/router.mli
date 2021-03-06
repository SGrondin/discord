open! Core_kernel

module Open : sig
  type 'a state = {
    internal_state: Internal_state.t;
    user_state: 'a;
  }

  type 'a router_action =
    | R_Forward   of 'a state
    | R_Reconnect of (float option * 'a state)
end

open Open

val forward : 'a state -> 'a router_action Lwt.t

val reconnect : wait:float option -> 'a state -> 'a router_action Lwt.t

type send = Websocket.Frame.t -> unit Lwt.t

val handle_message :
  Login.t -> send:send -> 'a state -> Data.Payload.t * Event.t -> 'a router_action Lwt.t
