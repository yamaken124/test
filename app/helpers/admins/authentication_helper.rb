module Admins::AuthenticationHelper

  private

  def allow_only_admins
    redirect_to :back unless current_admin.admins?
  end

  def allow_admins_and_nutritionists
    redirect_to :back unless (current_admin.admins? || current_admin.nutritionist?)
  end

end
