module Admins::ReportsHelper

  def count_user_registered_card
    @users_registered_card = 0
    User.all.each do |user|
      @users_registered_card += 1 if user.register_gmo_card?
    end
  end

end