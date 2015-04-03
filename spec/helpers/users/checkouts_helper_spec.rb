require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Users::CheckoutsHelper. For example:
#
# describe Users::CheckoutsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Users::CheckoutsHelper, type: :helper do
  describe 'check_as_default_address' do
    let(:user) { create(:user) }
    let(:default_address) { create(:address, user_id: user.id, is_main: true) }
    let(:nondefault_address) { create(:address, user_id: user.id, is_main: false) }
    it 'returns checked value if given address is the default address' do
      expect(check_as_default_address(nil, default_address)).to be_nil
      expect(check_as_default_address(default_address, nil)).to be_nil
      expect(check_as_default_address(default_address, default_address)).to match 'checked: "checked"'
      expect(check_as_default_address(nondefault_address, default_address)).to be_nil
    end
  end
end
