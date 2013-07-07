module Borrower
  module Transport

    # routes a file from -> to
    # @param from [String]
    # @param args [Hash]
    def move from, to, args={}
      content = take(from)
      content = Borrower.merge(content) if args[:merge]
      put( content, to )
    end

    # handles taking a file
    # @param from [String]
    # @return [String]
    def take from
      Path.contents(from)
    end

    # puts a file somewhere
    # @param content [String]
    # @param to [String]
    def put content, to
      FileUtils.mkdir_p( File.dirname(to) )
      File.open( to, 'w', internal_encoding: content.encoding ) do |file|
        file.write content
      end
    end

    module_function :move
    module_function :take
    module_function :put
  end
end