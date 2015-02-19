class GmoMultiPayment::Member
  def initialize(user)
    @user = user
  end

  def create
    url = GmoMultiPayment::Domain + "/payment/SaveMember.idPass"
    response = HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :MemberName => @user.name }
    })
    response.parsed_response.index("ErrCode").blank? ? true : false
  end

  def search
    url = GmoMultiPayment::Domain + "/payment/SearchMember.idPass"
    response = HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id }
    })
    response.parsed_response.index("ErrCode").blank? ? true : false
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
