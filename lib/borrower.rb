# utils
require 'fileutils'
require 'net/http'
require "net/https"
require "uri"

# borrower
require 'borrower/version'
require 'borrower/content'
require 'borrower/manifest'
require 'borrower/merge'
require 'borrower/public_api'

module Borrower::DSL

  # borrow a file and put it somewhere
  # by adding a merge: argument of true borrower will
  # parse the contents for additional borrow statements
  # to merge
  # @example borrow source to destination
  #   borrow "source/file", to: "destination/file"
  #
  # @example borrow and merge source to destination
  #   borrow "source/file", to: "file/destination", merge: true
  #
  # @param [String] path
  # @param [Hash] args
  # @option args [String] :to the destination path
  # @option args [Boolean] :merge wether to merge or not, defaults to `false`
  # @return [Void]
  def borrow path, args={}, &block
    destination = args.delete(:to) { raise ArgumentError, "missing 'to:' argument" }
    content = ContentString.new( Borrower.take(path) )
    yield self if block_given?
    Borrower.put content, destination, args
  end

  class ContentString
    attr_accessor :content
    def initialize content
      @content = content
    end
  end

end
include Borrower::DSL