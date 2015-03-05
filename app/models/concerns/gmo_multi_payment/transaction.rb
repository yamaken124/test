class GmoMultiPayment::Transaction
  def initialize(user, single_order_detail)
    @user = user
    @single_order_detail = single_order_detail
  end
 
  #transactionの初期::返り値にAccessIDとAccessPass
  #JobCd => GmoMultiPayment::Auth
  #TODO instance変数に入れれるところは入れる
  def entry(order_id, amount)
    url = GmoMultiPayment::Domain + "/payment/EntryTran.idPass"
    response = HTTParty.post( url, {body: 
                  { :ShopID => GmoMultiPayment::ShopID, 
                    :ShopPass => GmoMultiPayment::ShopPass, 
                    :OrderID => order_id, 
                    :JobCd => GmoMultiPayment::Auth,
                    :Amount => amount }
    })  
    p "AccessID=#{response.parsed_response.split("&")[0].split("=")[1]}"
    p "AccessPass=#{response.parsed_response.split("&")[1].split("=")[1]}"
    response
  end

  #card 有効性 CHECK 
  def auth(order_id, card_seq, access_id, access_pass)
    url = GmoMultiPayment::Domain + "/payment/ExecTran.idPass"
    response = HTTParty.post( url, {body: 
                  {:AccessID   => access_id,
                   :AccessPass => access_pass,
                   :OrderID    => order_id,
                   :Method     => "1",
                   :SiteID     => GmoMultiPayment::SiteID,
                   :SitePass   => GmoMultiPayment::SitePass,
                   :MemberID   => @user.id,
                   :CardSeq    => card_seq }
    })
    p response
    response
  end

  #card 実売上 SALES 
  def exec(order_id, amount, access_id, access_pass)
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:AccessID   => access_id,
                   :AccessPass => access_pass,
                   :Method     => "1",
                   :Amount     => amount,
                   :JobCd      => GmoMultiPayment::Sales,
                   :ShopID     => GmoMultiPayment::ShopID,
                   :ShopPass   => GmoMultiPayment::ShopPass }
    })  
  end

  def transaction_void(access_id, access_pass)
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => GmoMultiPayment::SiteID,
                   :SitePass    => GmoMultiPayment::SitePass,
                   :AccessID    => access_id,
                   :AccessPass  => access_pass, 
                   :JobCd       => GmoMultiPayment::Void}
    })
  end

  def tracsaction_return(access_id, access_pass)
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => GmoMultiPayment::SiteID,
                   :SitePass    => GmoMultiPayment::SitePass,
                   :AccessID    => access_id,
                   :AccessPass  => access_pass, 
                   :JobCd       => GmoMultiPayment::Void}
    })
  end
end
