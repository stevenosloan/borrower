require 'spec_helper'

describe Borrower do

  before :each do
    given_file "file.txt", "Hi I'm a file"
    given_file "merge.txt", "#= borrow '#{File.join( TMP, 'file.txt')}'"
  end

  after :each do
    cleanup_tmp
  end

  let (:local_file)       { File.join( TMP, 'file.txt' ) }
  let (:merge_file)       { File.join( TMP, 'merge.txt' ) }
  let (:remote_file)      { "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt" }
  let (:file_destination) { File.join( TMP, 'destination/file.txt' ) }

  it "borrows local files" do
    borrow local_file, to: file_destination
    Borrower.take( file_destination ).should == "Hi I'm a file"
  end

  it "borrows remote files" do
    borrow remote_file, to: file_destination
    Borrower.take( file_destination ).should == "Hello I'm a file"
  end

  it "borrows named local and remote files" do
    Borrower.manifest do |m|
      m.file "local", local_file
      m.file "remote", remote_file
    end
    borrow "local", to: file_destination
    borrow "remote", to: File.join( TMP, "remote.txt" )

    Borrower.take( file_destination ).should == "Hi I'm a file"
    Borrower.take( File.join( TMP, "remote.txt" ) ).should == "Hello I'm a file"
  end

  it "merges files if merge is set to true" do
    borrow merge_file, to: file_destination, merge: true
    Borrower.take( file_destination ).should == "Hi I'm a file"
  end

  it "raises an error if missing arg with key 'to'" do
    expect{ borrow( "foo", away: "bar" )}.to raise_error(ArgumentError)
  end

  it "yields content when passed a block" do
    borrow local_file, to: file_destination do |content|
      content + " foo"
    end

    Borrower.take( file_destination ).should == "Hi I'm a file foo"
  end

end