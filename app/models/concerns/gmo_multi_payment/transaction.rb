class GmoMultiPayment::Transaction
  def initialize(user)
    @user = user
  end
 
  #transactionの初期::返り値にAccessIDとAccessPass
  #JobCd => GmoMultiPayment::Auth
  #TODO instance変数に入れれるところは入れる
  def auth_entry(order_id, amount)
    url = GmoMultiPayment::Domain + "/payment/EntryTran.idPass"
    response = HTTParty.post( url, {body: 
                  { :ShopID => GmoMultiPayment::ShopID, 
                    :ShopPass => GmoMultiPayment::ShopPass, 
                    :OrderID => order_id, 
                    :JobCd => GmoMultiPayment::Auth,
                    :Amount => amount }
    })  
    {access_id: response.parsed_response.split("&")[0].split("=")[1], access_pass: response.parsed_response.split("&")[1].split("=")[1]}
  end


  #card 即時決済 取引登録 SALES(CAPTURE)
  def sales_entry(order_id, amount)
    url = GmoMultiPayment::Domain + "/payment/EntryTran.idPass"
    response = HTTParty.post( url, {body: 
                  { :ShopID => GmoMultiPayment::ShopID, 
                    :ShopPass => GmoMultiPayment::ShopPass, 
                    :OrderID => order_id, 
                    :JobCd => GmoMultiPayment::Capture,
                    :Amount => amount }
    })  
    {access_id: response.parsed_response.split("&")[0].split("=")[1], access_pass: response.parsed_response.split("&")[1].split("=")[1]}
  end

  #card 有効性 CHECK or SALES
  def exec(order_id, card_seq, access_id, access_pass)
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
    response.parsed_response.index("ErrCode").blank? ? true : false
  end

  #card 実売上 SALES 
  def change_to_sales(order_id, amount, access_id, access_pass)
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    response = HTTParty.post( url, {body: 
                  {:AccessID   => access_id,
                   :AccessPass => access_pass,
                   :Method     => "1",
                   :Amount     => amount,
                   :JobCd      => GmoMultiPayment::Sales,
                   :ShopID     => GmoMultiPayment::ShopID,
                   :ShopPass   => GmoMultiPayment::ShopPass }
    })
    response.parsed_response.index("ErrCode").blank? ? true : false
  end

  def serach(order_id)
    url = GmoMultiPayment::Domain + "/payment/SearchTrade.idPass"
    response = HTTParty.post( url, {body: 
                  {:ShopID     => GmoMultiPayment::ShopID,
                   :ShopPass   => GmoMultiPayment::ShopPass,
                   :OrderID    => order_id }
    }) 
    { order_id: response.parsed_response.split("&")[0].split("=")[1], 
      status: response.parsed_response.split("&")[1].split("=")[1], 
      process_date: response.parsed_response.split("&")[2].split("=")[1], 
      job_cd: response.parsed_response.split("&")[3].split("=")[1] }
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
