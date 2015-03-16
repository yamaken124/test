# == Schema Information
#
# Table name: payment_methods
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  environment   :string(255)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PaymentMethod < ActiveRecord::Base
  CreditCard = 1
end
