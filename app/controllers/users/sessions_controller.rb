class Users::SessionsController < Devise::SessionsController
  layout "users/users"
  def new
    @user = User.new
  end
end
