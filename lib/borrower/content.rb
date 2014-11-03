module Borrower
  class Content
    class << self

      # take the contents of the file at the path
      # @param [String] path
      # @return [String] the contents
      def get path
        path  = Borrower.find(path)
        obj = Item.new( path )

        return obj.content if obj.exists?

        raise "nothing exists at the provided path '#{path}'"
      end

      def put content, destination
        FileUtils.mkdir_p( File.dirname(destination) )
        File.open( destination, 'wb' ) do |file|
          file.write content
        end
      end

    end

    class Item
      def initialize path
        @path = path
      end

      def remote?
        @_remote ||= is_remote?
      end

      def exists?
        if remote?
          return ( fetch_from_remote(@path).msg.include? "OK" )
        else
          return File.exists? @path
        end
      end

      def content
        if remote? && exists?
          @_response.body
        else
          IO.read( @path )
        end
      end

      private

        def is_remote?
          if @path.match /http[s]?:\/\//
            return true
          end
          return false
        end

        def fetch_from_remote path, limit=10
          return @_response unless @_response.nil?

          raise Error, 'HTTP redirect too deep' if limit == 0
          response = get_response(path)

          case response
          when Net::HTTPSuccess then @_response = response
          when Net::HTTPRedirection then fetch_from_remote(response['location'], limit-1 )
          else
            @_response = response
          end
        end

        def get_response path
          uri = URI.parse(path)
          request = Net::HTTP.new(uri.host, uri.port)
          request.use_ssl = ( uri.scheme == "https" )

          return request.get(uri.request_uri)
        end

    end
  end
end