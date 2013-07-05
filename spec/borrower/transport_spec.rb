require 'spec_helper'
require 'borrower/transport'

describe Borrower::Transport do
  include Borrower::Transport

  describe "#take" do
    it "returns the correct contents" do
      take( File.join( Dir.pwd, 'spec/fixture', "file.txt" ) ).should == "Hi I'm a file"
    end
  end

  describe "#put" do
    path = File.join( Dir.pwd, 'tmp', 'file.txt' )

    after(:each) do
      `rm -rf #{File.dirname(path)}`
    end

    it "puts a string to a file" do
      put "hello", path
      take( path ).should == "hello"
    end
  end

  describe "#move" do
    path = File.join( Dir.pwd, 'tmp', 'file.txt' )

    after(:each) do
      `rm -rf #{File.dirname(path)}`
    end

    it "moves the file" do
      move( File.join( Dir.pwd, 'spec/fixture', 'file.txt'), path )
      take( path ).should == "Hi I'm a file"
    end

    it "overwrites an existing file" do
      put "hello", path
      take( path ).should == "hello" # just to make sure it was written to begin with
      move( File.join( Dir.pwd, 'spec/fixture', 'file.txt'), path )
      take( path ).should == "Hi I'm a file"
    end
  end

end