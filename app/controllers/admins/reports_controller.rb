class Admins::ReportsController < Admins::BaseController

  include Admins::AuthenticationHelper

  before_action :allow_only_admins

  def index
    @daily_detail = SingleOrderDetail.where('completed_on = ?', Date.today)
    @daily_one_click_detail = OneClickDetail.where('completed_on = ?', Date.today)
  end

end