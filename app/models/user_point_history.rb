class UserPointHistory < ActiveRecord::Base

  belongs_to :user
  # changed pointが正：pointが使われたことを意味する

end
