module Borrower
  class Manifest
    class ConfigFile

      attr_reader :files
      attr_reader :directories

      SOURCE_FILE = ::Borrower::Content::Item.new( 'manifest.borrower' )

      class << self

        def present?
          SOURCE_FILE.exists?
        end

      end

      def initialize
        require 'yaml'

        @files = {}.merge( manifest_file[:files] )
        @directories = [].push( *manifest_file[:directories] )
      end

      private

        def manifest_file
          return @_manifest_file if @manifest_file

          @_manifest_file = {
            files: raw_manifest_file['files'],
            directories: raw_manifest_file['directories'].split(' ')
          }
        end

        def raw_manifest_file
          YAML.load( SOURCE_FILE.content )
        end

    end
  end
end