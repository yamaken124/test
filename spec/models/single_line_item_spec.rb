# == Schema Information
#
# Table name: single_line_items
#
#  id                     :integer          not null, primary key
#  variant_id             :integer
#  single_order_detail_id :integer
#  quantity               :integer
#  price                  :integer
#  tax_rate_id            :integer
#  additional_tax_total   :integer
#  payment_state          :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe SingleLineItem, type: :model do
  describe 'invalid_quantity_check' do
    it 'sets quantity 0 if quantity is nil' do
      expect(create(:single_line_item, quantity: nil).quantity).to be_zero
    end
    it 'sets quantity 0 if quantity is under 0' do
      expect(create(:single_line_item, quantity: -1).quantity).to be_zero
    end

    let!(:single_line_item) { create(:single_line_item, quantity: 10) }
    context 'trying to set quantity nil' do
      it { expect { single_line_item.update(quantity: nil) }.to change(SingleLineItem, :count).by(-1)  }
    end
    context 'trying to set quantity -1' do
      it { expect { single_line_item.update(quantity: -1) }.to change(SingleLineItem, :count).by(-1)  }
    end
  end
end
