# utils
require 'fileutils'
require 'net/http'
require "net/https"
require "uri"

# borrower
require 'borrower/version'
require 'borrower/manifest'
require 'borrower/merge'
require 'borrower/path'
require 'borrower/transport'

module Borrower::DSL

  # borrow a file and put it somewhere
  # call syntax:
  #
  #    Borrower.borrow "path/to/file", to: "place/to/put/file"
  #
  # @param path [String]
  # @param args [Hash] only to: is looked at
  #
  def borrow path, args
    unless args.has_key? :to
      raise ArgumentError, "missing 'to:' argument"
    end

    Borrower::Transport.move path, args[:to]
  end

end
include Borrower::DSL