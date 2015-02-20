class Users::AccountsController < Users::BaseController
  def show
    @me = current_user
  end

  def edit
  end
end
