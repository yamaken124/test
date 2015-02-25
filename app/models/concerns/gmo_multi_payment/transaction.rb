class GmoMultiPayment::Transaction
  def initialize(user, bill)
    @user = user
    @bill = bill
  end
  
  #transactionの初期::返り値にAccessIDとAccessPass
  def entry
    url = GmoMultiPayment::Domain + "/payment/EntryTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :OrderID => @bill.id, 
                    :JobCd => GmoMultiPayment::Capture,
                    :Amount => @bill.total, 
                    :Tax => (@bill.additional_tax_total + @bill.shipment_total) }
    })   
  end

  def exec(card_seq)
    url = GmoMultiPayment::Domain + "/payment/ExecTran.idPass"
    HTTParty.post( url, {body: 
                  {:AccessID   => @bill.access_id,
                   :AccessPass => @bill.access_pass,
                   :OrderID    => @bill.id,
                   :Method     => 1,
                   :SiteID     => GmoMultiPayment::SiteID,
                   :SitePass   => GmoMultiPayment::SitePass,
                   :MemberID   => @bill.address.user.id,
                   :CardSeq    => card_seq }
    })  
  end

  def transaction_void
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => GmoMultiPayment::SiteID,
                   :SitePass    => GmoMultiPayment::SitePass,
                   :AccessID    => @bill.access_id,
                   :AccessPass  => @bill.access_pass, 
                   :JobCd       => GmoMultiPayment::Void}
    })
  end

  def tracsaction_return
    url = GmoMultiPayment::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => GmoMultiPayment::SiteID,
                   :SitePass    => GmoMultiPayment::SitePass,
                   :AccessID    => @bill.access_id,
                   :AccessPass  => @bill.access_pass, 
                   :JobCd       => GmoMultiPayment::Void}
    })
  end
end
