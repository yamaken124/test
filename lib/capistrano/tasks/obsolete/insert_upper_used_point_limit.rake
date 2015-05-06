namespace :insert_upper_used_point_limit do
  desc "insert_upper_used_point_limit"
  task :execute_insertion do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "insert_upper_used_point_limit:execute_insertion"
        end
      end
    end
  end
end