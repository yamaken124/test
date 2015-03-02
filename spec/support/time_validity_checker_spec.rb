require 'spec_helper'

shared_examples "is true when true" do

  describe "time validity checker" do
    it "is active" do
      expect(merchandise.active?).to eq true
    end

    it "is expired" do
      expect(expired_merchandise.expired?).to eq true
    end

    it "is preparing" do
      expect(preparing_merchandise.preparing?).to eq true
    end
  end

  describe "classify_validity" do
    it "is active" do
      expect(merchandise.classify_validity).to eq "time_validity.active"
    end

    it "is expired" do
      expect(expired_merchandise.classify_validity).to eq "time_validity.expired"
    end

    it "is preparing" do
      expect(preparing_merchandise.classify_validity).to eq "time_validity.preparing"
    end
  end

end