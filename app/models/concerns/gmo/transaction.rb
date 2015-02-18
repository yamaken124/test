class Gmo::Transaction
  def initialize(user, bill)
    @user = user
    @bill = bill
  end
  
  #transactionの初期::返り値にAccessIDとAccessPass
  def entry
    url = Gmo::Domain + "/payment/EntryTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :OrderID => @bill.id, 
                    :JobCd => Gmo::Capture,
                    :Amount => @bill.total, 
                    :Tax => (@bill.additional_tax_total + @bill.shipment_total) }
    })   
  end

  def exec(card_seq)
    url = Gmo::Domain + "/payment/ExecTran.idPass"
    HTTParty.post( url, {body: 
                  {:AccessID   => @bill.access_id,
                   :AccessPass => @bill.access_pass,
                   :OrderID    => @bill.id,
                   :Method     => 1,
                   :SiteID     => Gmo::SiteID,
                   :SitePass   => Gmo::SitePass,
                   :MemberID   => @bill.address.user.id,
                   :CardSeq    => card_seq }
    })  
  end

  def transaction_void
    url = Gmo::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => Gmo::SiteID,
                   :SitePass    => Gmo::SitePass,
                   :AccessID    => @bill.access_id,
                   :AccessPass  => @bill.access_pass, 
                   :JobCd       => Gmo::Void}
    })
  end

  def tracsaction_return
    url = Gmo::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => Gmo::SiteID,
                   :SitePass    => Gmo::SitePass,
                   :AccessID    => @bill.access_id,
                   :AccessPass  => @bill.access_pass, 
                   :JobCd       => Gmo::Void}
    })
  end
end
