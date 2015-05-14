namespace :insert_users_user_category do
  desc "insert users_user_category for registered users"
  task :execute_insertion do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "insert_users_user_category:execute_insertion"
        end
      end
    end
  end
end
