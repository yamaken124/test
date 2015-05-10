class Admins::ReportsController < Admins::BaseController

  include Admins::ReportsHelper

  def index
    @daily_detail = SingleOrderDetail.where('completed_on = ?', Date.today)
    @daily_one_click_detail = OneClickDetail.where('completed_on = ?', Date.today)

    count_user_registered_card if params[:credit] == 'true'
  end

end