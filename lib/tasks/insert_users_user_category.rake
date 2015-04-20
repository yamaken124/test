namespace :insert_users_user_category do
  desc "insert users_user_category for registered users"
  task :execute_insertion => :environment do
    SeedFu::Writer.write('./db/fixtures/users_user_category.rb', class_name: 'UsersUserCategory', constraints: [:id], seed_type: 'seed_once') do |w|
      User.all.each do |u|
        w << { user_id: u.id, user_category_id: '1' }
      end
    end
  end
end
