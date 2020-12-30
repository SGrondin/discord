open! Core_kernel

module Data = struct
  include Data

  module Basics = struct
    include Basics
  end
end

module Bot = Bot
module Login = Login
module Rest = Rest
