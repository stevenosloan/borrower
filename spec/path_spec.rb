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

  describe "#exists?" do

    it "recognizes missing files" do
      Borrower::Path.exists?("this/file/is/missing.rb").should be_false
      Borrower::Path.exists?("http://www.google.com/this/is/missing").should be_false
    end

    it "recognizes existing files" do
      Borrower::Path.exists?( "http://www.google.com" ).should be_true
      Borrower::Path.exists?( File.join( Dir.pwd, 'spec/fixture', "file.txt" ) ).should be_true
    end

  end


end