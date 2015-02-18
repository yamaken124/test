class Gmo::Transaction
  def initialize(user, order)
    @user = user
    @order = order
  end
  
  #transactionの初期::返り値にAccessIDとAccessPass
  def entry
    url = Gmo::Domain + "/payment/EntryTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :OrderID => @order.id, 
                    :JobCd => Gmo::Capture,
                    :Amount => @order.amount, 
                    :Tax => @order.tax}
    })   
  end

  def exec(card_seq)
    url = Gmo::Domain + "/payment/ExecTran.idPass"
    HTTParty.post( url, {body: 
                  {:AccessID   => "",
                   :AccessPass => "",
                   :OrderID    => "",
                   :Method     => 1,
                   :SiteID     => Gmo::SiteID,
                   :SitePass   => Gmo::SitePass,
                   :MemberID   => @user.id,
                   :CardSeq    => card_seq }
    })  
  end

  def transaction_void
    url = Gmo::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => Gmo::SiteID,
                   :SitePass    => Gmo::SitePass,
                   :AccessID    => "",
                   :AccessPass  => "" 
                   :JobCd       => Gmo::Void}
    })
  end

  def tracsaction_return
    url = Gmo::Domain + "/payment/AlterTran.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID      => Gmo::SiteID,
                   :SitePass    => Gmo::SitePass,
                   :AccessID    => "",
                   :AccessPass  => "" 
                   :JobCd       => Gmo::Void}
    })
  end
end
