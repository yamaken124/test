# == Schema Information
#
# Table name: bills_payments
#
#  id         :integer          not null, primary key
#  bill_id    :integer
#  payment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BillsPayment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payment
end
