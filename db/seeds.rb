# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def create_initial_user
  puts 'Create test user'
  puts '----------------'
  user_params = {}
  user_params[:email] = 'engineers_finc@googlegroups.com'
  user_params[:password] = 'x7DfFf97b-ko68tzz4PF'
  user_params[:password_confirmation] = user_params[:password]

  if user = User.where(email: user_params[:email]).first
    puts 'User already exists'
    print 'Please login via '
    access_token = user.oauth_access_tokens.first
    oauth_application = OauthApplication.find(1)
    puts "#{Rails.application.routes.url_helpers.oauth_authorization_path(access_token: access_token.token, consumer_key: oauth_application.consumer_key)}"
    return
  end

  user = User.new(user_params)
  user.save

  {}.tap do |oauth_access_token_params|
    oauth_access_token_params[:oauth_application_id] = 1
    oauth_access_token_params[:token] = 'YJDGsLfWz-cHL3qXB2QS'
    ap user.oauth_access_tokens.new
    user.oauth_access_tokens.new(oauth_access_token_params).save
  end

  puts 'User created !'
  print 'Please login via '
  puts "#{Rails.application.routes.url_helpers.oauth_authorization_path(access_token: access_token.token, consumer_key: oauth_application.consumer_key)}"
end

create_initial_user
