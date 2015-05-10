class Admins::ReportsController < Admins::BaseController

  include Admins::ReportsHelper

  before_action :set_date_field_value

  def index

    @selected_single_order_details = SingleOrderDetail.where('completed_on >= ?', pluck_date[:from]).where('completed_on <= ?', pluck_date[:to]) if params[:sales]
    @selected_one_click_details = OneClickDetail.where('completed_on >= ?', pluck_date[:from]).where('completed_on <= ?', pluck_date[:to]) if params[:lunch_sales]

    @selected_login_users = User.all.where('current_sign_in_at >= ?', pluck_date[:from]).where('current_sign_in_at <= ?', pluck_date[:to].to_date + 1) if params[:login_user_count]
    @selected_credit_cards = CreditCard.all.where('registered_at >= ?', pluck_date[:from]).where('registered_at < ?', pluck_date[:to].to_date + 1) if params[:credit_card_count]

    count_user_registered_card if params[:all_credit_count]
    @all_users = User.all if params[:all_user_count]

  end

  private

    def pluck_date
      params.require(:date).permit(:from, :to)
    end

    def set_date_field_value
      if params[:date].present?
        @serached_date_from = pluck_date[:from]
        @serached_date_to = pluck_date[:to]
      else
        @serached_date_from = Time.now.strftime('%Y-%m-%d')
        @serached_date_to = Time.now.strftime('%Y-%m-%d')
      end
  end

end