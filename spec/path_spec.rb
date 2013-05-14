require 'spec_helper'

describe Borrower::Path do

  describe "#remote?" do

    it "realizes a remote path" do
      Borrower::Path.remote?("http://google.com").should be_true
    end

  end
end