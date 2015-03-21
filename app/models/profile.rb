class Profile < ActiveRecord::Base

  include UserInfo

  belongs_to :user

end
