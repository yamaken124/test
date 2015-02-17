class Gmo::Member
  def initialize(user)
    @user = user
  end

  def create
    url = Gmo::Domain + "/payment/SaveMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id, 
                    :MemberName => @user.name }
    })
  end

  def search
    url = Gmo::Domain + "/payment/SearchMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id }
    })
  end

  def update
    url = Gmo::Domain + "/payment/UpdateMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id,
                    :MemberName => @user.name }
    })
  end

  def delete
    url = Gmo::Domain + "/payment/DeleteMember.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id }
    })
  end
end
