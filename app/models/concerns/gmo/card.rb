class Gmo::Card
  def initialize(user)
    @user = user
  end

  def create(card_no, expire)
    url = Gmo::Domain + "/payment/SaveCard.idPass"
    HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id, 
                    :CardNo => card_no,
                    :Expire => expire,
                    :DefaultFlag => 1}
    })
  end

  def search
     url = Gmo::Domain + "/payment/SearchCard.idPass"
     HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id, 
                    :SeqMode => 0 }
    })
  end

  def delete(card_seq)
     url = Gmo::Domain + "/payment/DeleteCard.idPass"
     HTTParty.post( url, {body: 
                  {:SiteID => Gmo::SiteID, 
                    :SitePass => Gmo::SitePass, 
                    :MemberID => @user.id, 
                    :CardSeq => card_seq}
    })
  end
end
