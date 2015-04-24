namespace :deploy do
  namespace :db do
    desc "run rake db:seed_fu"
    task :seed_fu => [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:seed_fu"
          end
        end
      end
    end

    desc "run rake db:seed"
    task :seed => [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:seed"
          end
        end
      end
    end
  end
end
