module Webmocks
  module FincAppApi
    def me_stub_request
      stub_request(:get, "#{Settings.internal_api.finc_app.host}/v2/me")
    end
  end
end

RSpec.configure do |config|
  config.include Webmocks::FincAppApi, :type => :all
end
