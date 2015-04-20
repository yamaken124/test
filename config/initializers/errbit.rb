Airbrake.configure do |config|
  config.api_key = 'a219f9e6a309b4861a4b835242486338'
  config.host    = 'errbit-sample-finc.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.environment_name = Rails.env.production? ? "#{Rails.env}:#{`hostname`}" : Rails.env
end
