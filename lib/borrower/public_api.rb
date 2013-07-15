# the public api methods for borrower
module Borrower
  module PublicAPI

    # retrieve the contents of a file
    # that is remote or local
    #
    # @param from [String] the path to the file
    # @return [String] contents of the file
    def take from
      Transport.take from
    end

    # write the content to a destination file
    #
    # @param content [String] content for the file
    # @param to [String] path to write contents to
    # @return [Void]
    def put content, to
      Transport.put content, to
    end

    # parse through the content and merge
    # matched file contents
    #
    # @param content [String] content to parse
    # @param options [Hash] merging options
    #
    #   {
    #     comment: "#"
    #     # => the comment delimeter to match against
    #   }
    #
    # @return [String] the merged content
    def merge content, options={}
      Merge.new( content, options ).output
    end

    # returns the manifest to add lookup
    # directories or named files
    # @param &block :yields: Manifest
    #
    #     manifest do |m|
    #       m.file "jquery", "http://code.jquery.com/jquery-1.10.2.min.js"
    #       # => adds an alias for jquery
    #       m.dir  "vendor"
    #       # => adds the vendor dir to the lookup paths
    #     end
    #
    # @return [Manifest]
    def manifest &block
      @_manifest ||= Manifest.new
      yield @_manifest if block_given?
      return @_manifest
    end

    # lookup a file or path in the manifest
    #
    # @param file [String]
    # @return [String] path to the file
    def find file
      manifest.find file
    end

  end

  extend PublicAPI
end