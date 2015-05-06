class Users::AccountsController < Users::BaseController

  def top
    @taxons = current_user.shown_taxon
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

  def show
    @me = current_user
    @wellness_mileage = @me.wellness_mileage
  end

end
