class SubscriptionTerm < ActiveRecord::Base
  belongs_to :subscription_order
end
