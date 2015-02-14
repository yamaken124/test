FactoryGirl.define do
  factory :subscription_order_detail do
    subscription_order nil
number "MyString"
item_total 1
total 1
completed_at "2015-02-14 15:59:32"
address nil
shipment_total 1
additional_tax_total 1
confirmation_delivered false
guest_token "MyString"
adjustment_total 1
item_count 1
date "2015-02-14"
lock_version 1
  end

end
