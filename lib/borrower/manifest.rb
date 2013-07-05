module Borrower

  class << self
    def manifest &block
      @_manifest ||= Manifest.new
      yield @_manifest if block_given?
    end

    def find file
      path = @_manifest.files.fetch(file) { false }
      return path if path

      matches = []
      @_manifest.directories.each do |dir|
        Dir[File.join( dir, '*' )].each do |possibility|
          matches << possibility if possibility.match( file )
        end
      end
      matches.sort { |a,b| a.length <=> b.length }.first
    end
  end

  class Manifest

    attr_reader :files
    attr_reader :directories

    def initialize
      @files = {}
      @directories = []
    end

    def file name, path
      @files[name] = path
    end

    def dir dir
      @directories.push dir
    end

  end
end