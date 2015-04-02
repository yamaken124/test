source 'https://rubygems.org'

ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Manage constant
gem 'rails_config'

# test
group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'database_cleaner'
  gem 'pry-byebug'
end

group :test do
  gem 'webmock'
  gem 'simplecov', require: false
end

# ERD
gem 'rails-erd', group: :development

# debug
group :development, :staging, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'hirb'
  gem 'hirb-unicode'

  gem 'tapp'
  gem 'letter_opener_web'
  gem 'awesome_print'
  gem 'quiet_assets'
end

group :development, :staging, :heroku_staging do
  gem 'rack-dev-mark'
end

gem 'rails_12factor', group: :heroku_staging

# seed
gem 'seed-fu'
gem 'annotate'

gem 'bullet', group: :development

# Authentication
gem 'devise'

# HttpRequest
gem 'httparty'

# bootstrap
gem 'adminlte-rails'

# image uploader
gem 'carrierwave'
gem 'rmagick'
gem 'fog'
gem 'unf' # due to a fog warning

# pager
gem "kaminari"

# state machines
gem 'aasm'

gem 'awesome_nested_set'

#background processing
gem "delayed_job"
gem "delayed_job_active_record"
gem "daemons"

gem "zip_code_jp"