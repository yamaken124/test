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

require 'rails_helper'

RSpec.describe SubscriptionTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
