module Users::AddressesHelper
  def set_first_name
    if params["action"] == "edit"
      @address.first_name
    else #new
      current_user.try(:profile).try(:first_name)
    end
  end

 def set_last_name
    if params["action"] == "edit"
      @address.last_name
    else #new
      current_user.try(:profile).try(:last_name)
    end
  end

end
