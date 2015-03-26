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
  has_one :shipment
  belongs_to :payment_method
  belongs_to :address
  belongs_to :user
  belongs_to :single_order_detail

  before_create :set_number

  private

    def set_number
      self.number = "s" + Time.now.to_i.to_s + self.single_order_detail_id.to_s
    end

    def set_shipment_params
      if self.payment_method_id == 1
        {payment_id: self.id, address_id: self.address_id, state: :ready}
      else
        {payment_id: self.id, address_id: self.address_id, state: :pending}
      end
    end

end
