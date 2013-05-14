require 'borrower/version'
require 'borrower/path'
require 'borrower/transport'

module Borrower
  include Transport

  class << self

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
        raise "missing 'to:' argument"
      end

      move path, args[:to]
    end

  end
end