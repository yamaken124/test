module Users::AddressesHelper
  def set_first_name(referer, address)
    if request.referer.include?("addresses/new") 
      @address.first_name
    else 
      current_user.try(:profile).try(:first_name)
    end
  end

 def set_last_name(referer, address)
    if request.referer.include?("addresses/new") 
      @address.last_name
    else 
      current_user.try(:profile).try(:last_name)
    end
  end

end
