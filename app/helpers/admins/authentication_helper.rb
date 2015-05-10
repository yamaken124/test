module Admins::AuthenticationHelper

  private

  def allow_only_admins
    redirect_to :back unless current_admin.admins?
  end

end
