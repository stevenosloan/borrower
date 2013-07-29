module Borrower
  class Merge

    def initialize content, options={}
      @content = content
      @comment_symbol = pick_comment_symbol options
    end

    def output
      merge_borrow_statements
    end

    private

      def pick_comment_symbol options
        options.fetch(:comment) do
          CommentSymbol.find_symbol_for options.fetch(:type) { "default" }
        end
      end

      def merge_borrow_statements
        @content.gsub /(?:#{@comment_symbol})= borrow '(.*?)'/ do |match|
          contents_from_file($1)
        end
      end

      def contents_from_file path
        Content.get(path)
      end

      module CommentSymbol
        class << self

          def find_symbol_for type
            symbols.fetch(type) { default }
          end

          private

            def default
              "#"
            end

            def symbols
              {
                'js'          => '//',
                'javascript'  => '//',
                'css'         => '//',
                'stylesheet'  => '//'
              }
            end

        end
      end

  end
end