require 'spec_helper'

describe Borrower do

  before :each do
    given_file "file.txt", "Hi I'm a file"
    given_file "merge.txt", "#= borrow '#{File.join( TMP, 'file.txt')}'"
    given_file "merge.js", "//= borrow '#{File.join( TMP, 'file.txt')}'"
  end

  after :each do
    cleanup_tmp
  end

  let (:local_file)       { File.join( TMP, 'file.txt' ) }
  let (:merge_file)       { File.join( TMP, 'merge.txt' ) }
  let (:js_merge_file)    { File.join( TMP, 'merge.js' ) }
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

  it "doesn't merge file if merge is not set" do
    borrow merge_file, to: file_destination
    Borrower.take( file_destination ).should == "#= borrow '#{File.join( TMP, 'file.txt')}'"
  end

  it "merges files if merge is set to true" do
    borrow merge_file, to: file_destination, merge: true
    Borrower.take( file_destination ).should == "Hi I'm a file"
  end

  it "merges files with the file type it is passed" do
    borrow js_merge_file, to: file_destination, merge: true, type: 'js'
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

  context "binary files" do

    let(:binary_file) { File.join( Dir.pwd, 'spec/fixture', 'image.png' ) }
    let(:binary_dest) { File.join( TMP, 'image.png' ) }

    it "borrows them as it would any other file" do
      borrow binary_file, to: binary_dest

      expect( File.exists?(binary_dest) ).to be_true
    end

    it "skips merge attempts" do
      borrow binary_file, to: binary_dest, merge: true

      expect( File.exists?(binary_dest) ).to be_true
    end

    it "skips block manipulation" do
      borrow binary_file, to: binary_dest do |f|
        f.gsub( "foo", "bar" )
      end

      expect( File.exists?(binary_dest) ).to be_true
    end

    it "doesn't skip block manipulation of odd, but utf-8 files" do
      source = File.join( Dir.pwd, 'spec/fixture', 'non_ascii.txt' )
      dest   = File.join( TMP, 'non_ascii.txt' )

      borrow source, to: dest do |f|
        "woo"
      end
      expect( File.exists?(dest) ).to be_true
      expect( IO.read(dest) ).to eq "woo"
    end

  end

  describe "on_conflict options" do
    it "doesn't pass an option to put if none is set" do
      expect( Borrower ).to receive(:put).with( "Hi I'm a file", file_destination )

      borrow local_file, to: file_destination
    end

    it "passes an option if set" do
      expect( Borrower ).to receive(:put).with( "Hi I'm a file", file_destination, :skip )

      borrow local_file, to: file_destination, on_conflict: :skip
    end
  end

end