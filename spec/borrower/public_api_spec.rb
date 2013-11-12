require 'spec_helper'

describe Borrower::PublicAPI do

  after :each do
    cleanup_tmp
  end

  describe "#put" do
    context "when no file exists at destination" do
      [ :overwrite, :prompt, :skip, :raise_error ].each do |on_conflict|
        context "when on_conflict is set to :#{on_conflict}" do
          it "puts the contents in a file at the destination" do
            destination = File.join( TMP, 'destination/file.txt' )
            Borrower.put "Hello World", destination, on_conflict

            expect( Borrower.take(destination) ).to eq "Hello World"
          end
        end
      end
    end

    context "when a file exists at destination" do

      let(:destination) { File.join( TMP, "file.txt" ) }
      before :each do
        given_file "file.txt", "I'm conflicted"
      end

      context "when on_conflict is set to :overwrite" do
        it "overwrites the contents of the file" do
          Borrower.put "Hello World", destination, :overwrite

          expect( Borrower.take(destination) ).not_to eq "I'm conflicted"
          expect( Borrower.take(destination) ).to eq "Hello World"
        end
      end

      context "when on_confict is set to :prompt" do
        it "overwrites to file if response is y" do
          fake_stdin("y") do
            Borrower.put "Hello World", destination, :prompt
          end

          expect( Borrower.take(destination) ).not_to eq "I'm conflicted"
          expect( Borrower.take(destination) ).to eq "Hello World"
        end

        it "skips file if response is no" do
          fake_stdin("n") do
            Borrower.put "Hello World", destination, :prompt
          end

          expect( Borrower.take(destination) ).not_to eq "Hello World"
          expect( Borrower.take(destination) ).to eq "I'm conflicted"
        end
      end

      context "when on_conflict is set to :skip" do
        it "doesn't overwrite the contents of the file" do
          Borrower.put "Hello World", destination, :skip

          expect( Borrower.take(destination) ).not_to eq "Hello World"
          expect( Borrower.take(destination) ).to eq "I'm conflicted"
        end
      end

      context "when on_conflict is set to :raise_error" do
        it "raises an error" do
          expect{
            Borrower.put "Hello World", destination, :raise_error
          }.to raise_error
        end
      end
    end
  end

end