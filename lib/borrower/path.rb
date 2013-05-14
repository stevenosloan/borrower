module Borrower
  module Path
    class << self

      # take the contents of the file at the path
      # @param path [String]
      # @return [String] the contents
      def contents path
        if exists? path
          if remote? path
            fetch_from_remote(path).body
          else
            return IO.read(path)
          end
        else
          raise "nothing exists at the provided path '#{path}'"
        end
      end

      # check if the file exists for borrowing
      # @param path [String]
      # @return [Boolean]
      def exists? path
        if remote? path
          return ( fetch_from_remote(path).msg == "OK" )
        else
          return File.exists? path
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

      # get the contents of a remote file, handling redirection
      # and ssh protocols
      # @param path [String]
      # @param limit [Integer] (optional)
      # @return [String]
      def fetch_from_remote path, limit=10
        raise Error, 'HTTP redirect too deep' if limit == 0
        response = get_response(path)

        case response
        when Net::HTTPSuccess then response
        when Net::HTTPRedirection then fetch_from_remote(response['location'], limit-1 )
        else
          response
        end
      end

      # build a Net::HTTP request object and
      # returns the response
      # @param path[String]
      # @return [Net::HTTPResponse]
      def get_response path
        uri = URI.parse(path)
        request = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == "https"
          request.use_ssl = true
          request.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request.ssl_version = :SSLv3
        end

        return request.get(uri.request_uri)
      end

    end
  end
end