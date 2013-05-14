require 'spec_helper'

describe Borrower::Path do

  describe "#remote?" do
    it "realizes a remote vs. local paths" do
      Borrower::Path.remote?("http://google.com").should be_true
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

  describe "#contents" do

    it "returns the content of the files" do
      Borrower::Path.contents( File.join( Dir.pwd, 'spec/fixture', "file.txt" ) ).should == "Hi I'm a file"
    end

    it "raises an error for a missing file" do
      expect{ Borrower::Path.contents( "this/file/is/missing.rb" ) }.to raise_error(RuntimeError)
    end

  end

end