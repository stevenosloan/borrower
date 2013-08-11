require 'borrower/manifest/file'

module Borrower
  class Manifest

    attr_reader :files
    attr_reader :directories

    def initialize
      @files = {}
      @directories = []

      if Manifest::ConfigFile.present?
        @manifest_file = Manifest::ConfigFile.new
        @files = @files.merge( @manifest_file.files )
        @directories = @directories.push( *@manifest_file.directories )
      end
    end

    def file name, path
      @files[name] = path
    end

    def dir dir
      @directories.push dir
    end

    def find file
      obj = Content::Item.new(file)
      return file if obj.remote? || obj.exists?

      path = check_for_file_in_manifest_files(file) || false
      return path if path

      path = check_for_file_in_manifest_directories(file) || false
      return path if path

      raise "Could not file #{file}"
    end

    private

      def check_for_file_in_manifest_files file
        files.fetch(file) { false }
      end

      def check_for_file_in_manifest_directories file
        matches = []
        directories.each do |dir|
          Dir[File.join( dir, '*' )].each do |possibility|
            matches << possibility if possibility.match( file )
          end
        end
        path = matches.sort { |a,b| a.length <=> b.length }.first
      end

  end
end