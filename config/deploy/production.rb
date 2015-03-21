set :stage, :production
set :branch, 'master'
set :rbenv_type, :user
set :rbenv_ruby, '2.2.1'
set :rails_env, 'production'
set :unicorn_rack_env, 'production'
set :bundle_without,  [:development, :test, :heroku_staging, :staging]

set :application_server_addrs, [
  '54.199.149.61',
  '54.178.237.8'
]

# set :cron_server_addr, '54.64.23.242'
set :db_server_addr, fetch(:application_server_addrs).first

fetch(:application_server_addrs).each do |server_addr|
  server server_addr, user: 'ubuntu', roles: %w(app web worker unicorn_roles)
end

# server fetch(:cron_server_addr), user: 'ubuntu', roles: %w(cron web)
server fetch(:db_server_addr), user: 'ubuntu', roles: %w(db web)
