# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  number               :string(255)
#  item_total           :integer
#  total                :integer
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer
#  additional_tax_total :integer
#  adjustment_total     :integer
#  item_count           :integer
#  date                 :date
#  lock_version         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe SingleOrderDetail, type: :model do

  describe 'defined methods' do
    let(:single_order_detail) {create(:single_order_detail)}

    it 'set_completed_on' do
      @single_order_detail = create(:single_order_detail)
      @single_order_detail.completed_on = nil
      expect(@single_order_detail.set_completed_on).to eq single_order_detail.completed_on
    end
  end

end
