# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  item_total           :integer          default(0), not null
#  tax_rate_id          :integer
#  total                :integer          default(0), not null
#  paid_total           :integer
#  completed_on         :date
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer          default(0), not null
#  additional_tax_total :integer          default(0), not null
#  used_point           :integer          default(0)
#  adjustment_total     :integer          default(0), not null
#  item_count           :integer          default(0), not null
#  lock_version         :integer          default(0), not null
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

  describe 'item_total_with_tax' do
    let(:single_order_detail) { build(:single_order_detail, item_total: 100, additional_tax_total: 8) }

    it 'returns sum of item_total & additional_tax_total' do
      expect(single_order_detail.item_total_with_tax).to eq 108
    end
  end

  describe 'allowed_max_use_point' do

    let(:user) { create(:user) }
    let(:purchase_order) { create(:purchase_order, user_id: user.id) }
    let(:single_order) { create(:single_order, purchase_order_id: purchase_order.id) }
    let(:single_order_detail) { build(:single_order_detail, single_order_id: single_order.id, item_total: 100, additional_tax_total: 8) }

    it 'returns wellness_mileage if item total is larger' do
      allow_any_instance_of(User).to receive(:wellness_mileage).and_return(107)
      expect(single_order_detail.allowed_max_use_point).to eq 107
    end

    it 'returns item total if wellness mileage is larger' do
      allow_any_instance_of(User).to receive(:wellness_mileage).and_return(109)
      expect(single_order_detail.allowed_max_use_point).to eq 108
    end
  end
end
