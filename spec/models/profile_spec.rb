# == Schema Information
#
# Table name: profiles
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  last_name       :string(255)      default(""), not null
#  first_name      :string(255)      default(""), not null
#  last_name_kana  :string(255)      default(""), not null
#  first_name_kana :string(255)      default(""), not null
#  phone           :string(255)      default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'self.phone_regexp' do
    subject { Profile.phone_regexp }
    it { is_expected.to match '08012345678' }
    it { is_expected.to match '0801234567' }
    it { is_expected.not_to match '080123456' }
    it { is_expected.not_to match '080123456789' }
  end
end
