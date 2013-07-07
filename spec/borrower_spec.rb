require 'spec_helper'

describe Borrower do

  before :each do
    given_file "file.txt", "Hi I'm a file"
  end

  after :each do
    cleanup_tmp
  end

  let (:local_file)       { File.join( TMP, 'file.txt' ) }
  let (:remote_file)      { "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt" }
  let (:file_destination) { File.join( TMP, 'destination/file.txt' ) }

  it "borrows local files" do
    borrow local_file, to: file_destination
    Borrower::Transport.take( file_destination ).should == "Hi I'm a file"
  end

  it "borrows remote files" do
    borrow remote_file, to: file_destination
    Borrower::Transport.take( file_destination ).should == "Hello I'm a file"
  end

  it "raises an error if missing arg with key 'to'" do
    expect{ borrow( "foo", away: "bar" )}.to raise_error(ArgumentError)
  end

end