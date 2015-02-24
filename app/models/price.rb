# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  variant_id :integer
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Price < ActiveRecord::Base
  belongs_to :variant

end
