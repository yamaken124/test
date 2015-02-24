class Admins::BillsController < ApplicationController
  layout "admins/admins"
  before_action :is_bills              
  
  def index
  end

  def show
  end

  #description of the state 
  #laundering_planned: 洗替予定
  #laundering_failure: 洗替失敗
  #laundering_planned: 洗替成功
  #complete: 売上計上済み
  def regular_purchase
    case params[:state]
    when "laundering_planned" then
      laundering_planned
    when "laundering_failure" then
      laundering_failure
    when "laundering_success" then 
      laundering_success 
    when "complete" then
      complete 
    else
     laundering_planned 
    end
  end

  private
  def laundering_planned 
    render 'admins/bills/regular_purchase/laundering_planned'
  end

  def laundering_failure
    render 'admins/bills/regular_purchase/laundering_failure'
  end

  def laundering_success
    render 'admins/bills/regular_purchase/laundering_success'
  end

  def complete
    render 'admins/bills/regular_purchase/complete'
  end

  def is_bills
    @is_bills = "true"
  end
end
