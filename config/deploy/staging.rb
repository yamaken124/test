set :stage, :staging
set :branch, 'master'
set :rbenv_type, :user
set :rbenv_ruby, '2.2.1'
set :rails_env, 'staging'
set :unicorn_rack_env, 'staging'
set :bundle_without,  [:development, :test, :heroku_staging]

set :application_server_addrs, [
  '54.178.185.30'
]

set :cron_server_addr, fetch(:application_server_addrs).first
set :db_server_addr, fetch(:cron_server_addr)

fetch(:application_server_addrs).each do |server_addr|
  server server_addr, user: 'ubuntu', roles: %w(app web worker)
end
server fetch(:cron_server_addr), user: 'ubuntu', roles: %w(cron web)
server fetch(:db_server_addr), user: 'ubuntu', roles: %w(db web)
