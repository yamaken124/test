class Admins::SessionsController < Devise::SessionsController
  before_action :http_basic_auth, unless: :development_env?

  protected

    def http_basic_auth
      authenticate_or_request_with_http_basic do |user, pass|
        user == Settings.http_basic.user && pass == Settings.http_basic.pass
      end
    end

    def development_env?
      Rails.env.development?
    end

    def after_sign_in_path_for(resource)
      current_admin.admins? ? admins_products_path : admins_shipments_singles_path
    end
end
