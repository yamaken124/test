namespace :insert_stock_quantity do
  desc "insert stock quantity for all variants"
  task :execute_insertion do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "insert_stock_quantity:execute_insertion"
        end
      end
    end
  end
end