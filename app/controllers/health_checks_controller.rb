class HealthChecksController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def show
    User.first.present?
    render text: :ok
  end
end
