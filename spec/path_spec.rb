require 'spec_helper'

describe Borrower::Path do

  describe "#remote?" do

    it "realizes a remote path" do
      Borrower::Path.remote?("http://google.com").should be_true
    end

    it "recognizes a local path" do
      Borrower::Path.remote?("/path/to/file.rb").should be_false
    end

  end
end