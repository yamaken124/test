class GmoMultiPayment::Member
  def initialize(user)
    @user = user
  end

  def create
    url = GmoMultiPayment::Domain + "/payment/SaveMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :MemberName => @user.name }
    })
  end

  def search
    url = GmoMultiPayment::Domain + "/payment/SearchMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id }
    })
  end

  def update
    url = GmoMultiPayment::Domain + "/payment/UpdateMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id,
                    :MemberName => @user.name }
    })
  end
  
  #userを削除する時に同時に実行する。一度削除したら二度と使用不可
  def delete
    url = GmoMultiPayment::Domain + "/payment/DeleteMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id }
    })
  end
end
