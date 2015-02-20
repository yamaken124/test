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

require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
