class Admins::Bills::SubscriptionsController < Admins::BaseController

  include Admins::AuthenticationHelper

  before_action :allow_only_admins

  def index
  end
end
