require 'spec_helper'
require 'borrower/transport'

describe Borrower::Transport do
  include Borrower::Transport

  before :each do
    given_file "file.txt", "Hi I'm a file"
  end

  after :each do
    cleanup_tmp
  end

  let (:local_file)       { File.join( TMP, 'file.txt' ) }
  let (:destination_path) { File.join( TMP, 'destination/file.txt' ) }


  describe "#take" do
    it "returns the correct contents" do
      take( local_file ).should == "Hi I'm a file"
    end
  end

  describe "#put" do

    it "puts a string to a file" do
      put "hello", destination_path
      take( destination_path ).should == "hello"
    end
  end

  describe "#move" do

    it "moves the file" do
      move( local_file, destination_path )
      take( destination_path ).should == "Hi I'm a file"
    end

    it "overwrites an existing file" do
      put "hello", destination_path
      take( destination_path ).should == "hello" # just to make sure it was written to begin with
      move( local_file, destination_path )
      take( destination_path ).should == "Hi I'm a file"
    end
  end

end