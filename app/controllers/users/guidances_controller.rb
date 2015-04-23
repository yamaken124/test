class Users::GuidancesController < Users::BaseController

  def show
    render params[:name]
  end

end
