class SubscriptionOrder < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :variant
end
