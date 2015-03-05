FactoryGirl.define do
  factory :oauth_access_token do
    user nil
    oauth_application_id 1
    token "MyString"
    expires_in 1
    scopes "MyString"
  end
end
