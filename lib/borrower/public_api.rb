# the public api methods for borrower
module Borrower
  module PublicAPI

    # retrieve the contents of a file
    # that is remote or local
    #
    # @param [String] from the path to the file
    # @return [String] contents of the file
    def take from
      Borrower::Content.get from
    end

    # write the content to a destination file
    #
    # @param [String] content content for the file
    # @param [String] to path to write contents to
    # @return [Void]
    def put content, to, options={}
      Borrower::Content.put content, to, options
    end

    # parse through the content and merge
    # matched file contents
    #
    # @param [String] content content to parse
    # @param [Hash] options merging options
    # @option options [String] :comment the comment delimeter to match against
    # @return [String] the merged content
    def merge content, options={}
      Merge.new( content, options ).output
    end

    # returns the manifest to add lookup
    # directories or named files
    # @example add a file alias and directory
    #
    #   manifest do |m|
    #     m.file "jquery", "http://code.jquery.com/jquery-1.10.2.min.js"
    #     # => adds an alias for jquery
    #     m.dir  "vendor"
    #     # => adds the vendor dir to the lookup paths
    #   end
    #
    # @yield [Manifest]
    # @return [Manifest]
    def manifest &block
      @_manifest ||= Manifest.new
      yield @_manifest if block_given?
      return @_manifest
    end

    # lookup a file or path in the manifest
    #
    # @param [String] file
    # @return [String] path to the file
    def find file
      manifest.find file
    end

  end

  extend PublicAPI
end