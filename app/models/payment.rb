# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  amount            :integer
#  used_point        :integer
#  payment_method_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Payment < ActiveRecord::Base
  include Payment::Transition
  belongs_to :payment_method
  belongs_to :address

  def set_number
    self.number = "s" + Time.now.strftime("%Y%m%d%H%M%S").to_s + self.single_order_detail_id.to_s
	end

end