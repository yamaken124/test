class User < ActiveRecord::Base
  module FincApp
    def self.included(klass)
      klass.class_eval do
        def me_in_finc_app
          return {} if Rails.env.development?
          if access_token = oauth_access_tokens.first
            ::FincApp.me(access_token.token)
          else
            {}
          end
        end

        def wellness_mileage
          return 0 if Rails.env.development?

          if access_token = oauth_access_tokens.first
            ::FincApp.wellness_mileage(access_token.token)
          else
            0
          end
        end
      end
    end
  end
end
