class GmoMultiPayment::Subscription
  def self.laundering_row(user)
    gmo_cards = GmoMultiPayment::Card.new(user).search
    return if gmo_cards.count == 0
    default_card_seq = ""
    gmo_cards.each_with_index do |gmo_card, i|
      default_card_seq = i if gmo_card[:DefaultFlag].to_i == 1 
    end
    [user.id, default_card_seq, ""]
  end

  def self.regist_launderings
  end

  def self.sale_row(user)
    gmo_cards = GmoMultiPayment::Card.new(user).search
    return if gmo_cards.count == 0
    default_card_seq = ""
    gmo_cards.each_with_index do |gmo_card, i|
      default_card_seq = i if gmo_card[:DefaultFlag].to_i == 1 
    end
    [GmoMultiPayment::ShopID, user.id, default_card_seq, 0, Date.today.strftime("%Y%m%d"), "yyyymmdd-order_id", "", "amount", "tax", 1, "", "", "", "00001", "", "", "", "", ""]
  end

  def self.regist_sales_result
  end
end
