module FincApp
  module UsersApi
    def self.included(klass)
      klass.class_eval do
        def self.me(access_token, version: 'v2')
          url = "#{finc_app_api_host}/#{version}/me"
          response = JSON.parse(HTTParty.get(url, { body: { access_token: access_token } }).body)
          if response.has_key?('user')
            response['user']
          else
            raise ActiveRecord::RecordNotFound
          end
        end

        def self.sign_in(email, password, version: 'v1')
          return if email.blank? || password.blank?
          url = "#{finc_app_api_host}/#{version}/users/login"
          response = JSON.parse(HTTParty.post(url, { body: { email: email, password: password } }).body)

          if access_token = response['access_token']
            begin
              oauth_application = OauthApplication.find_by(consumer_key: Settings.oauth_applications.finc_app.consumer_key) || (raise ActiveRecord::RecordNotFound)
              oauth_access_token = OauthAccessToken.find_by(oauth_application_id: oauth_application.id, token: access_token) || (raise ActiveRecord::RecordNotFound)

              User.find(oauth_access_token.user_id)
            rescue ActiveRecord::RecordNotFound
              nil
            end
          end
        end

      end
    end
  end
end
