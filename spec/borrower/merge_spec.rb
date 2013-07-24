require 'spec_helper'

describe "moving files with a merge" do

  before :each do
    given_file "foo.txt", "hello I'm merged text"
    Borrower.manifest do |m|
      m.file "foo.txt", File.join( TMP, "foo.txt" )
    end
  end

  after :each do
    cleanup_tmp
  end

  it "merges contents of files" do
    Borrower.merge("#= borrow 'foo.txt'").should == "hello I'm merged text"
  end

  it "lets you pass other comment symbols" do
    Borrower.merge("//= borrow 'foo.txt'", comment: "//" ).should == "hello I'm merged text"
  end

  it "handles multiple files to merge with" do
    given_file "woo.txt", "woo"
    given_file "multiple.txt", <<-content
      #= borrow 'foo.txt'
      #= borrow 'woo.txt'

      Some other things
    content
    Borrower.manifest do |m|
      m.file 'multiple.txt', File.join( TMP, 'multiple.txt' )
      m.file 'woo.txt', File.join( TMP, 'woo.txt' )
    end

    Borrower.merge( Borrower.take(Borrower.find("multiple.txt"))).should == <<-output
      hello I'm merged text
      woo

      Some other things
    output
  end

end