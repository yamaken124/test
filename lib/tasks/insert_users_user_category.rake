namespace :insert_users_user_category do
  desc "insert users_user_category for registered users"
  task :execute_insertion => :environment do
    User.where.not(id: UsersUserCategory.where(user_category_id: 1).pluck(:user_id)).each do |user|
      UsersUserCategory.where(user_id: user.id).first_or_create(user_category_id: 1)
    end
  end
end
