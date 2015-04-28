# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  used_point_total       :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'wellness_mileage' do
    context 'user has access_token' do
      before do
        stub_request(:get, "#{Settings.internal_api.finc_app.host}/v2/wellness_mileage").to_return(status: 200, body: { wellness_mileage: 3 }.to_json)
        @user = create(:user)
        @oauth_access_token = create(:oauth_access_token, user_id: @user.id)
      end
      it 'returns diff in total_points at finc_app_me and used_point_total' do
        expect(@user.wellness_mileage).to eq 3
      end
    end

    context 'user has no access_token' do
      before do
        stub_request(:get, "#{Settings.internal_api.finc_app.host}/v2/wellness_mileage").to_return(status: 200, body: { wellness_mileage: 3 }.to_json)
        @user = create(:user)
      end
      it 'returns diff in total_points at finc_app_me and used_point_total' do
        expect(@user.wellness_mileage).to eq 0
      end
    end
  end
end
