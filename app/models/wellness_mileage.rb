class WellnessMileage
  def self.add(point, user)
    return { 'success' => true } if Rails.env.development?

    if access_token = user.oauth_access_tokens.first
      ::FincApp.add_wellness_mileage(access_token.token, point)
    else
      { 'success' => false }
    end
  end
end
