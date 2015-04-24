class UsersUserCategory < ActiveRecord::Base

  belongs_to :user
  belongs_to :user_category
end
