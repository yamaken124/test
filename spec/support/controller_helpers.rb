module ControllerHelpers

  def user_sign_in(user)
    sign_in_helper(user, :user)
  end

  def admin_sign_in(admin)
    sign_in_helper(admin, :admin)
  end

  def sign_in_helper(klass, klass_name)
     if klass.nil?
      request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => klass_name})
      allow(controller).to receilve(:"current_#{klass_name}") { nil }
    else
      request.env['warden'].stub(:authenticate! => klass)
      allow(controller).to receive(:"current_#{klass_name}") { klass }
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end
