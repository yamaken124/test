class UserCategory < ActiveRecord::Base

  has_one :users_user_category
  has_one :user_categories_taxon

end
