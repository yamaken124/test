class BillsPayment < ActiveRecord::Base
  belongs_to :bill
  belongs_to :payment
end
