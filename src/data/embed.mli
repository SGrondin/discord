open! Core_kernel
open! Basics

module Type : sig
  type t =
    | Rich
    | Image
    | Video
    | Gifv
    | Article
    | Link
    | Unknown of string
  [@@deriving variants]

  include Shared.S_Enum with type t := t
end

module Thumbnail : sig
  type t = {
    url: Url.t option;
    proxy_url: Url.t option;
    height: int option;
    width: int option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Video : sig
  type t = {
    url: Url.t option;
    height: int option;
    width: int option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Image : sig
  type t = {
    url: Url.t option;
    proxy_url: Url.t option;
    height: int option;
    width: int option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Provider : sig
  type t = {
    name: string option;
    url: Url.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Author : sig
  type t = {
    name: string option;
    url: Url.t option;
    icon_url: Url.t option;
    proxy_icon_url: Url.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Footer : sig
  type t = {
    text: string;
    icon_url: Url.t option;
    proxy_icon_url: Url.t option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

module Field : sig
  type t = {
    name: string;
    value: string;
    inline: bool option;
  }
  [@@deriving fields]

  include Shared.S_Object with type t := t
end

type t = {
  title: string option;
  type_: Type.t option;
  description: string option;
  url: Url.t option;
  timestamp: Timestamp.t option;
  color: int option;
  footer: Footer.t option;
  image: Image.t option;
  thumbnail: Thumbnail.t option;
  video: Video.t option;
  provider: Provider.t option;
  author: Author.t option;
  fields: Field.t list option;
}
[@@deriving fields]

include Shared.S_Object with type t := t
