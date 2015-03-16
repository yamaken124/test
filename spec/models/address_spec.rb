# == Schema Information
#
# Table name: addresses
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  last_name         :string(255)
#  first_name        :string(255)
#  address           :string(255)
#  city              :string(255)
#  zipcode           :string(255)
#  phone             :string(255)
#  alternative_phone :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Address, type: :model do

  describe 'validations' do
    it 'assign address' do
      user = create(:user)
      address = create(:address, user_id: user.id)
      expect(address).to be_valid
    end
  end


  describe 'defined methods' do

    let(:user) { create(:user) }
    let(:address) { create(:address, user_id: user.id) }

    it 'expect full name' do
      expect(address.name).to eq address.last_name + " " + address.first_name
    end

    it 'not reach_upper_limit' do
      expect(Address.reach_upper_limit?(user)).to eq false
    end

    it 'reach_upper_limit' do
      create_list(:address, 3, user_id: user.id)
      expect(Address.reach_upper_limit?(user)).to eq true
    end

    it 'update_all_not_main' do
      create(:address, user_id: user.id, is_main: true)
      Address.update_all_not_main(user)
      expect(Address.where(user_id: user.id).pluck(:is_main).first).to eq false
    end

  end

end