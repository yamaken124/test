module ControllerHelpers

  def user_sign_in(user)
    sign_in_helper(user, :user)
  end

  def admin_sign_in(admin)
    sign_in_helper(admin, :admin)
  end

  def sign_in_helper(klass, klass_name)
    @request.env["devise.mapping"] = Devise.mappings[klass_name]
    sign_in klass
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end
