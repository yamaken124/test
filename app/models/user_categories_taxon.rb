class UserCategoriesTaxon < ActiveRecord::Base

  belongs_to :user_category
  belongs_to :taxon

end
