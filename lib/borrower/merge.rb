module Borrower
  class << self
    def merge content
      merger = Merge.new content
      merger.output
    end
  end

  class Merge
    def initialize content
      @content = content
    end

    def output
      sub_borrow_statements
    end

    private

      def sub_borrow_statements
        @content.gsub /#= borrow '(.*?)'/ do |match|
          contents_from_file($1)
        end
      end

      def contents_from_file path
        ::Borrower::Path.contents(::Borrower.find(path))
      end

  end
end