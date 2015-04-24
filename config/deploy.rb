# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'finc_store'
set :repo_url, 'git@github.com:FiNCDeveloper/finc_store.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{fetch(:application)}"

set :deploy_via, :remote_cache

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :delayed_job_server_role, :worker

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :migrate, 'db:seed_fu'
  after 'db:seed_fu', 'db:seed'
  after 'db:seed_fu', 'insert_users_user_category:execute_insertion'
  # after 'db:seed_fu', 'insert_temp_data_to_shipment:execute_insertion'
  after :publishing, 'unicorn:restart'

  after 'deploy:publishing', 'delayed_job:restart'
end
