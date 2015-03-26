# == Schema Information
#
# Table name: tax_rates
#
#  id            :integer          not null, primary key
#  amount        :decimal(6, 5)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe TaxRate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
