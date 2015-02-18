class GmoMultiPayment::Card
  def initialize(user)
    @user = user
  end

  def create(card_no, expire)
    url = GmoMultiPayment::Domain + "/payment/SaveCard.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :CardNo => card_no,
                    :Expire => expire,
                    :DefaultFlag => 1}
    })
  end

  def search
     url = GmoMultiPayment::Domain + "/payment/SearchCard.idPass"
     HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :SeqMode => 0 }
    })
  end

  def delete(card_seq)
     url = GmoMultiPayment::Domain + "/payment/DeleteCard.idPass"
     HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :CardSeq => card_seq}
    })
  end
end
