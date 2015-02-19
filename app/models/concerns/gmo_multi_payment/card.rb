class GmoMultiPayment::Card
  def initialize(user)
    @user = user
  end

  def create(card_no, expire)
    url = GmoMultiPayment::Domain + "/payment/SaveCard.idPass"
    response = HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :CardNo => card_no,
                    :Expire => expire,
                    :DefaultFlag => 1}
    })
    response.parsed_response.index("ErrCode").blank? ? true : false
  end

  def update(card_no, expire, card_seq, default_flag)
    url = GmoMultiPayment::Domain + "/payment/SaveCard.idPass"
    response = HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :CardNo => card_no,
                    :Expire => expire,
                    :CardSeq => card_seq,
                    :DefaultFlag => default_flag}
    })
    response.parsed_response.index("ErrCode").blank? ? true : false
  end


  def search
     url = GmoMultiPayment::Domain + "/payment/SearchCard.idPass"
     response = HTTParty.post( url, {body: 
                  {:SiteID => GmoMultiPayment::SiteID, 
                    :SitePass => GmoMultiPayment::SitePass, 
                    :MemberID => @user.id, 
                    :SeqMode => 0 }
     })
     response.parsed_response.index("ErrCode").blank? ? GmoMultiPayment::Card.parse_response(response.parsed_response) : false
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

  def self.parse_response(response)
    parsed_response = []
    length = response.split("&")[0].split("=")[1].split("|").length
    for i in 0..(length-1) do
      row = {}
      response.split("&").each do |formula|
        row[formula.split("=")[0].to_sym] = formula.split("=")[1].split("|")[i]
      end
      parsed_response << row
    end
    parsed_response
  end
end
