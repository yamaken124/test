module UserInfo

  extend ActiveSupport::Concern

  def name
    "#{last_name} #{first_name}"
  end

end