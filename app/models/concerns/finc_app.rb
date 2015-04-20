module FincApp
  include FincApp::UsersApi

  def self.finc_app_api_host
    @finc_app_host ||= Settings.internal_api.finc_app.host
  end

  def self.save_user_from_finc_app(finc_app_user)
    password = Devise.friendly_token + Devise.friendly_token
    password_params = { password: password, password_confirmation: password }
    user = User.where(email: finc_app_user['email']).first_or_initialize(password_params)
    finc_app_user[:profile_id] = user.profile.try(:id)
    user.update(FincApp.filter_user_params(finc_app_user))
    user.create_user_category
    user
  end

  def self.filter_user_params(finc_app_user_params)
    { profile_attributes: {} }.tap do |update_params|
      if finc_app_user_params[:telephone].present? && finc_app_user_params[:telephone] =~ Profile.phone_regexp
        update_params[:profile_atttributes][:phone] = finc_app_user_params[:telephone]
      end
      update_params[:profile_atttributes][:id] = finc_app_user_params[:profile_id] if finc_app_user_params[:profile_id]
      %w(last_name first_name last_name_kana first_name_kana).each do |attribute|
        if finc_app_user_params[attribute].present?
          update_params[:profile_attributes][attribute.to_sym] = finc_app_user_params[attribute]
        end
      end
    end
  end
end
