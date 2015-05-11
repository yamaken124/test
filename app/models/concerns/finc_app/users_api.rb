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

        def self.wellness_mileage(access_token, version: 'v2')
          url = "#{finc_app_api_host}/#{version}/wellness_mileage"
          response = JSON.parse(HTTParty.get(url, { body: { access_token: access_token } }).body)
          if response.has_key?('wellness_mileage')
            response['wellness_mileage'].to_i
          else
            0
          end
        end

        def self.add_wellness_mileage(access_token, point, version: 'v2')
          url = "#{finc_app_api_host}/#{version}/wellness_mileage/add"
          response = JSON.parse(HTTParty.post(url, { body: { access_token: access_token, point: point } }).body)
        end

        def self.get_finc_user_id(access_token, version: 'v1')
          url = "#{finc_app_api_host}/internal/#{version}/users/finc_user_id"
          JSON.parse(HTTParty.get(url, { body: { access_token: access_token } }).body)
        end

        def self.business_account(access_token, version: 'v3')
          url = "#{finc_app_api_host}/#{version}/business_account"
          JSON.parse(HTTParty.get(url, { body: { access_token: access_token } }).body)
        end
      end
    end
  end
end
