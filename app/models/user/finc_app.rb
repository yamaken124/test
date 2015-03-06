class User < ActiveRecord::Base
  module FincApp
    def self.included(klass)
      klass.class_eval do
        def me_in_finc_app
          if access_token = oauth_access_tokens.first
            ::FincApp.me(access_token.token)
          else
            {}
          end
        end
      end
    end
  end
end
