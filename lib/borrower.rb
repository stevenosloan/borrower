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
  # @example borrow and gsub all exclamation marks
  #   borrow "source/file", to: "file/destination" do |content|
  #     content.gsub("!", '.')
  #   end
  #
  # @param [String] path
  # @param [Hash] args
  # @option args [String] :to the destination path
  # @option args [Boolean] :merge wether to merge or not, defaults to `false`
  # @return [Void]
  def borrow path, args={}, &block
    destination = args.delete(:to) { raise ArgumentError, "missing 'to:' argument" }
    content = Borrower.take(path)
    if block_given?
      content = yield content
    end
    Borrower.put content, destination, args
  end

end
include Borrower::DSL