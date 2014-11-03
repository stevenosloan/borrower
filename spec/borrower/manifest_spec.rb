require 'spec_helper'

describe Borrower::Manifest do

  before :each do
    given_files [ "baz.txt", "files/baz.txt", "files/woo.txt", "files/foo.txt" ]
  end

  after :each do
    cleanup_tmp
  end

  let(:me_key)      { "me" }
  let(:me_file)     { File.join( TMP, "test.txt" ) }
  let(:remote_key)  { "remote" }
  let(:remote_file) { "https://gist.github.com/stevenosloan/5578606/raw/97ab1305184bdeac33472f9f1fcc1c9e278a1bb3/dummy.txt" }
  let(:base_dir)  { File.join( TMP ) }
  let(:files_dir) { File.join( TMP, 'files' ) }
  let(:expanded_file) { "~/.bashrc" }

  context "with no manifest file" do

    before :each do
      Borrower.manifest do |m|
        m.file me_key, me_file
        m.file remote_key, remote_file
        m.dir base_dir
        m.dir files_dir
      end
    end

    it "finds a file path based on key name if set" do
      Borrower.find(me_key).should == me_file
    end

    it "returns remote paths if given fully resolved" do
      Borrower.find("http://google.com").should == "http://google.com"
    end

    it "finds named remote files" do
      Borrower.find(remote_key).should == remote_file
    end

    it "creates list of files from directories" do
      Borrower.find("baz.txt").should       == File.join( TMP, "baz.txt" )
      Borrower.find("files/baz.txt").should == File.join( TMP, "files/baz.txt" )
      Borrower.find("woo.txt").should       == File.join( TMP, "files/woo.txt" )
      Borrower.find("foo.txt").should       == File.join( TMP, "files/foo.txt" )
    end

    it "expands path to find files" do
      expect( Borrower.find(expanded_file) ).to eq File.expand_path(expanded_file)
    end

    it "raises error if no file is found" do
      expect { Borrower.find("doesnt_exist.txt") }.to raise_error
    end

  end

  context "with a borrower manifest file" do

    before :each do
      # ensure the manifest is reset
      if Borrower.send(:instance_variable_defined?, :@_manifest)
        Borrower.send(:remove_instance_variable, :@_manifest)
      end

      # move working dir to TMP
      Dir.chdir TMP
    end

    after :each do
      # move the working dir to root
      Dir.chdir ROOT
    end

    before :each do
      given_config %Q{
files:
  #{me_key}: #{me_file}
  #{remote_key}: #{remote_file}

directories:
  #{base_dir}
  #{files_dir}
      }
    end

    it "detects that it is present" do
      Borrower::Manifest::ConfigFile.present?.should be_truthy
    end

    it "adds the given files to the manifest" do
      Borrower.manifest.files[me_key].should == me_file
      Borrower.manifest.files[remote_key].should == remote_file
    end

    it "add the given directories to the manifest" do
      Borrower.manifest.directories.include?( base_dir ).should be_truthy
      Borrower.manifest.directories.include?( files_dir ).should be_truthy
    end

  end

end