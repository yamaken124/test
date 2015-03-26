# == Schema Information
#
# Table name: oauth_access_tokens
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  oauth_application_id :integer          not null
#  token                :string(255)      default(""), not null
#  expires_in           :integer          default(600), not null
#  scopes               :string(255)      default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :oauth_access_token do
    user nil
    oauth_application_id 1
    token "MyString"
    expires_in 1
    scopes "MyString"
  end
end
