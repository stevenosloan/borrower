module Borrower
  module Transport

    # routes a file from -> to
    # @param from [String]
    def move from, to
      put( take(from), to )
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
      File.open( to, 'w+' ) do |file|
        file.write content
      end
    end

  end
end