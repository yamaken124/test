class SingleOrder < ActiveRecord::Base
  belongs_to :purchase_order
end
