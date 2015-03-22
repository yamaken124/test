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
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'wellness_mileage' do
    let(:user) { create(:user, used_point_total: 5) }

    it 'returns diff in total_points at finc_app_me and used_point_total' do
      allow_any_instance_of(User).to receive(:me_in_finc_app).and_return({ 'total_points' => 10 })
      expect(user.wellness_mileage).to eq 0
    end

    it 'returns 0 if me_at_finc_app is not found' do
      expect(user.wellness_mileage).to eq 0
    end
  end
end
