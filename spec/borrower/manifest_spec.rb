require 'spec_helper'

describe Borrower::Manifest do

  before :each do
    given_files [ "baz.txt", "files/baz.txt", "files/woo.txt", "files/foo.txt" ]
  end

  after :each do
    cleanup_tmp
  end

  let(:me_file)     { File.join( TMP, "test.txt" ) }
  let(:remote_file) { "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt" }
  let(:base_dir)  { File.join( TMP ) }
  let(:files_dir) { File.join( TMP, 'files' ) }

  context "no manifest file" do

    before :each do
      Borrower.manifest do |m|
        m.file "me", me_file
        m.file "remote", remote_file
        m.dir base_dir
        m.dir files_dir
      end
    end

    it "finds a file path based on key name if set" do
      Borrower.find("me").should == me_file
    end

    it "returns remote paths if given fully resolved" do
      Borrower.find("http://google.com").should == "http://google.com"
    end

    it "finds named remote files" do
      Borrower.find("remote").should == remote_file
    end

    it "creates list of files from directories" do
      Borrower.find("baz.txt").should       == File.join( TMP, "baz.txt" )
      Borrower.find("files/baz.txt").should == File.join( TMP, "files/baz.txt" )
      Borrower.find("woo.txt").should       == File.join( TMP, "files/woo.txt" )
      Borrower.find("foo.txt").should       == File.join( TMP, "files/foo.txt" )
    end

    it "raises error if no file is found" do
      expect { Borrower.find("doesnt_exist.txt") }.to raise_error
    end

  end

  context "with a borrower manifest file" do

    before :all do
      # ensure the manifest is reset
      Borrower.send(:remove_instance_variable, :@_manifest)
    end

    before :each do
      given_file "multiple.txt", %Q{
        files:
          me: #{me_file}
          remote: #{remote_file}

        directories:
          #{base_dir}
          #{files_dir}
      }
    end

    it "adds the given files to the manifest" do
      Borrower.manifest.files.has_key?(me_file).should be_true
      Borrower.manifest.files.has_key?(remote_file).should be_true
    end

    it "add the given directories to the manifest" do
      Borrower.manifest.dir.include?( base_dir ).should be_true
      Borrower.manifest.dir.include?( files_dir ).should be_true
    end

  end

end