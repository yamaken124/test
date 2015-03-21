class Users::AccountsController < Users::BaseController
  def show
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

  def edit
  end
end
