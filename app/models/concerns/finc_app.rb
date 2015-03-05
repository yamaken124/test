module FincApp
  include FincApp::UsersApi

  def self.finc_app_api_host
    @finc_app_host ||= Settings.internal_api.finc_app.host
  end

  def self.save_user_from_finc_app(finc_app_user)
    password = Devise.friendly_token + Devise.friendly_token
    password_params = { password: password, password_confirmation: password }
    user = User.where(email: finc_app_user['email']).first_or_initialize(password_params)
    user.update(FincApp.filter_user_params(finc_app_user))
    user
  end

  def self.filter_user_params(finc_app_user_params)
    update_params = { profile_attributes: {} }
    update_params[:profile_attributes][:last_name] = finc_app_user_params['last_name']
    update_params[:profile_attributes][:first_name] = finc_app_user_params['first_name']
    update_params[:profile_attributes][:last_name_kana] = finc_app_user_params['last_name_kana']
    update_params[:profile_attributes][:first_name_kana] = finc_app_user_params['first_name_kana']
    update_params[:profile_attributes][:phone] = finc_app_user_params['telephone']
    update_params
  end
end
