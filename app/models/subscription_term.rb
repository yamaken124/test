# == Schema Information
#
# Table name: subscription_terms
#
#  id                    :integer          not null, primary key
#  subscription_order_id :integer
#  term                  :integer
#  interval              :integer
#  interval_unit         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class SubscriptionTerm < ActiveRecord::Base
  belongs_to :subscription_order
end
