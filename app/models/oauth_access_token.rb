class OauthAccessToken < ActiveRecord::Base
  belongs_to :user
end
