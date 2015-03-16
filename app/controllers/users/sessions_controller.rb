class Users::SessionsController < Devise::SessionsController
  layout "users/users"
  def new
    if Rails.env.development?
      super
    else
      redirect_to 'http://wellness-survey-lp.finc.co.jp'
    end
  end
end
