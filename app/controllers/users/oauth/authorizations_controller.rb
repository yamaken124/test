module Users
  module Oauth
    class AuthorizationsController < Users::Oauth::BaseController
      before_action :redirect_to_root_if_signed_in
      before_action :check_valid_key_and_token!

      def create
        if sign_in_with_access_token(persisted_access_token)
          redirect_to root_path
        else
          # finc_app 以外の認証も対応する必要が出たら実装する
          sign_up_with_fincapp(oauth_application, params[:access_token])
          redirect_to edit_profile_path(continue: :credit_cards)
        end
      end

      private

        def redirect_to_root_if_signed_in
          redirect_to root_path and return if user_signed_in?
        end

        def check_valid_key_and_token!
          raise ActionController::BadRequest if params[:consumer_key].blank? ||
            params[:access_token].blank? ||
            oauth_application.blank?
        end

        def oauth_application
          @oauth_application ||= OauthApplication.where(consumer_key: params[:consumer_key]).first
        end

        def persisted_access_token
          @persisted_access_token ||= \
            OauthAccessToken.where(oauth_application_id: oauth_application.id) \
            .where(token: params[:access_token]).first
        end

        def sign_up_with_fincapp(oauth_finc_app, access_token)
          fincapp_user = FincApp.me(access_token)
          user = FincApp.save_user_from_finc_app(fincapp_user)
          user.oauth_access_tokens.where(oauth_application_id: oauth_finc_app.id) \
            .where(token: access_token).first_or_create
          sign_in(:user, user)
          user
        end

        def sign_in_with_access_token(persisted_access_token)
          if persisted_access_token && user = User.where(id: persisted_access_token.user_id).first
            sign_in(:user, user)
            user
          end
        end
    end
  end
end
