require 'rails_helper'

RSpec.describe Product, :type => :model do

  describe "TimeValidityChecker" do

    it_behaves_like "is true when true" do
      let(:merchandise) { create(:product) }
      let(:expired_merchandise) { create(:expired_product) }
      let(:preparing_merchandise) { create(:preparing_product) }
    end

  end

end
