require 'spec_helper'

describe Borrower::Manifest do

  before :each do
    given_files [ "baz.txt", "files/baz.txt", "files/woo.txt", "files/foo.txt" ]
    Borrower.manifest do |m|
      m.file "me", File.join( TMP, "test.txt" )
      m.file "remote", "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt"
      m.dir File.join( TMP )
      m.dir File.join( TMP, 'files' )
    end
  end

  after :each do
    cleanup_tmp
  end

  it "finds a file path based on key name if set" do
    Borrower.find("me").should == File.join( TMP, "test.txt" )
  end

  it "returns remote paths if given fully resolved" do
    Borrower.find("http://google.com").should == "http://google.com"
  end

  it "finds named remote files" do
    Borrower.find("remote").should == "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt"
  end

  it "creates list of files from directories" do
    Borrower.find("baz.txt").should == File.join( TMP, "baz.txt" )
    Borrower.find("files/baz.txt").should == File.join( TMP, "files/baz.txt" )
    Borrower.find("woo.txt").should == File.join( TMP, "files/woo.txt" )
    Borrower.find("foo.txt").should == File.join( TMP, "files/foo.txt" )
  end

  it "raises error if no file is found" do
    expect { Borrower.find("doesnt_exist.txt") }.to raise_error
  end

end