# == Schema Information
#
# Table name: payments
#
#  id                     :integer          not null, primary key
#  amount                 :integer
#  source_id              :integer
#  source_type            :string(255)
#  gmo_access_id          :string(255)
#  gmo_access_pass        :string(255)
#  gmo_card_seq_temporary :integer
#  used_point             :integer          default(0), not null
#  payment_method_id      :integer
#  address_id             :integer
#  single_order_detail_id :integer
#  number                 :string(255)
#  user_id                :integer
#  state                  :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Payment < ActiveRecord::Base
  include Payment::Transition
  # has_one :shipment
  belongs_to :payment_method
  belongs_to :address
  belongs_to :user
  belongs_to :single_order_detail

  before_create :set_number

  UsedPointLimit = 9999

  private

    def set_number
      self.number = "s" + Time.now.to_i.to_s + self.single_order_detail_id.to_s
    end

    def set_state_by_payment_method
      if self.payment_method_id == 1
        "ready"
      else
        "pending"
      end
    end

end
