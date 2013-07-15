# the public api methods for borrower
module Borrower
  module PublicAPI

    def take from
      Transport.take from
    end

    def put content, to
      Transport.put content, to
    end

    def merge content, options={}
      Merge.new( content, options ).output
    end

    def manifest &block
      @_manifest ||= Manifest.new
      yield @_manifest if block_given?
      return @_manifest
    end

    def find file
      manifest.find file
    end

  end

  extend PublicAPI
end