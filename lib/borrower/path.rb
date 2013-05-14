module Borrower
  module Path
    class << self

      # take the contents of the file at the path
      # @param path [String]
      # @return [String] the contents
      def contents path
        if exists? path
        else
          raise "nothing exists at the provided path '#{path}'"
        end
      end

      # check if the file exists for borrowing
      # @param path [String]
      # @return [Boolean]
      def exists? path
        if remote? path
          # use net-ssh to check response
        else
          # File.exists? path
        end
      end

      # check if the path is remote or local
      # @param path [String]
      # @return [Boolean]
      def remote? path
        pattern = /http[s]?:\/\//
        if path.match(pattern)
          return true
        end

        return false
      end

    end
  end
end