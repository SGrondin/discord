open! Core_kernel
open! Basics

type t = int option

include Shared.S_Base with type t := t

include Data.Payload.S with type t := t
