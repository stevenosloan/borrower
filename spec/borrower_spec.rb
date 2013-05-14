require 'spec_helper'

describe Borrower do

  describe "#borrow" do
    path = File.join( Dir.pwd, 'tmp', 'file.txt' )

    after(:each) do
      `rm -rf #{File.dirname(path)}`
    end

    it "borrows local files" do
      borrow File.join( Dir.pwd, 'spec/fixture', 'file.txt'), to: path
      Borrower::Transport.take( path ).should == "Hi I'm a file"
    end

    it "borrows remote files" do
      borrow "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt", to: path
      Borrower::Transport.take( path ).should == "Hello I'm a file"
    end

    it "raises an error if missing to:" do
      expect{ borrow( "foo", away: "bar" )}.to raise_error(ArgumentError)
    end
  end

end