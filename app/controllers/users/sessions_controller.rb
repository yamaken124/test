class Users::SessionsController < Devise::SessionsController
  before_action :http_basic_auth, if: :staging_env?

  layout "users/users"

  def new
    if Rails.env.development?
      super
    else
      redirect_to 'http://wellness-survey-lp.finc.co.jp'
    end
  end

  protected

    def http_basic_auth
      authenticate_or_request_with_http_basic do |user, pass|
        user == Settings.http_basic.user && pass == Settings.http_basic.pass
      end
    end

    def staging_env?
      Rails.env.staging? || Rails.env.heroku_staging?
    end
end
