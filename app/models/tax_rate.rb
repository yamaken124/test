# == Schema Information
#
# Table name: tax_rates
#
#  id            :integer          not null, primary key
#  amount        :decimal(10, )
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TaxRate < ActiveRecord::Base
end
