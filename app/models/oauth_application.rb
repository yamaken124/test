# == Schema Information
#
# Table name: oauth_applications
#
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  consumer_key    :string(255)      default(""), not null
#  consumer_secret :string(255)      default(""), not null
#  redirect_uri    :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OauthApplication < ActiveRecord::Base
end
