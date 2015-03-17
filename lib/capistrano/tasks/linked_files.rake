namespace :deploy do
  namespace :linked_files do
    desc 'Upload config/database.yml'
    task :database do
      on roles(:app) do |host|
        if test "[ ! -d #{shared_path}/config ]"
          execute "mkdir -p #{shared_path}/config"
        end
        upload!('config/database.yml', "#{shared_path}/config/database.yml")
      end
    end

    desc 'Upload config/database.yml'
    task :secrets do
      on roles(:app) do |host|
        if test "[ ! -d #{shared_path}/config ]"
          execute "mkdir -p #{shared_path}/config"
        end
        upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
      end
    end
  end
end
