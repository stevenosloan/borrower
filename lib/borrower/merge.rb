module Borrower
  class Merge

    def initialize content, options={}
      @content = content
      @comment_symbol = options.fetch(:comment) { default_comment_symbol }
    end

    def output
      merge_borrow_statements
    end

    private

      def default_comment_symbol
        "#"
      end

      def merge_borrow_statements
        @content.gsub /(?:#{@comment_symbol})= borrow '(.*?)'/ do |match|
          contents_from_file($1)
        end
      end

      def contents_from_file path
        Path.contents(path)
      end

  end
end