class Admins::Bills::SubscriptionsController < Admins::BaseController

  include Admins::AuthenticationHelper

  before_action :allow_admins_and_nutritionists

  def index
  end
end
