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
      end
    end
  end
end
