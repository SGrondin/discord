open! Core_kernel
open! Basics

module Type = struct
  module Self = struct
    type t =
      | Rich [@name "rich"]
      | Image [@name "image"]
      | Video [@name "video"]
      | Gifv [@name "gifv"]
      | Article [@name "article"]
      | Link [@name "link"]
      | Unknown of string
    [@@deriving sexp, compare, equal, variants, yojson { strict = false }]

    let here = [%here]
  end

  include Self
  include Enum.Make_String (Self)
end

module Thumbnail = struct
  type t = {
    url: Url.t option; [@default None]
    proxy_url: Url.t option; [@default None]
    height: int option; [@default None]
    width: int option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Video = struct
  type t = {
    url: Url.t option; [@default None]
    height: int option; [@default None]
    width: int option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Image = struct
  type t = {
    url: Url.t option; [@default None]
    proxy_url: Url.t option; [@default None]
    height: int option; [@default None]
    width: int option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Provider = struct
  type t = {
    name: string option; [@default None]
    url: Url.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Author = struct
  type t = {
    name: string option; [@default None]
    url: Url.t option; [@default None]
    icon_url: Url.t option; [@default None]
    proxy_icon_url: Url.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Footer = struct
  type t = {
    text: string;
    icon_url: Url.t option; [@default None]
    proxy_icon_url: Url.t option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Field = struct
  type t = {
    name: string;
    value: string;
    inline: bool option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

module Self = struct
  type t = {
    title: string option; [@default None]
    type_: Type.t option; [@default None] [@key "type"]
    description: string option; [@default None]
    url: Url.t option; [@default None]
    timestamp: Timestamp.t option; [@default None]
    color: int option; [@default None]
    footer: Footer.t option; [@default None]
    image: Image.t option; [@default None]
    thumbnail: Thumbnail.t option; [@default None]
    video: Video.t option; [@default None]
    provider: Provider.t option; [@default None]
    author: Author.t option; [@default None]
    fields: Field.t list option; [@default None]
  }
  [@@deriving sexp, compare, equal, fields, yojson { strict = false }]
end

include Self
