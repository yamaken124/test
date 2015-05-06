namespace :insert_temp_data_to_shipment do
  desc "insert temp data to shipment"
  task :execute_insertion do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "insert_temp_data_to_shipment:execute_insertion"
        end
      end
    end
  end
end