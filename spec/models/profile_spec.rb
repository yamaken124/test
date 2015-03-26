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
  pending "add some examples to (or delete) #{__FILE__}"
end
