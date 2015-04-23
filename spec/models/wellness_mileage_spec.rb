require 'rails_helper'

RSpec.describe WellnessMileage, type: :model do
  describe 'wellness_mileage' do
    context 'user has access_token' do
      before do
        stub_request(:post, "#{Settings.internal_api.finc_app.host}/v2/wellness_mileage/add").to_return(status: 201, body: { 'success' => true }.to_json)
        @user = create(:user)
        create(:oauth_access_token, user_id: @user.id, token: 'access')
      end

      it { expect(WellnessMileage.add(10, @user)).to match({ 'success' => true })}
    end

    context 'user has no access_token' do
      before do
        stub_request(:post, "#{Settings.internal_api.finc_app.host}/v2/wellness_mileage/add").to_return(status: 201, body: { 'success' => true }.to_json)
        @user = create(:user)
      end

      it { expect(WellnessMileage.add(10, @user)).to match({ 'success' => false })}
    end
  end
end
