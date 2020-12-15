open! Core_kernel
open! Basics

type t = { resumable: bool } [@@unboxed]

include Shared.S_Base with type t := t
