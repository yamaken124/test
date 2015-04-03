class String
  def to_b
    case self.to_s.downcase
    when "true", "yes", "ok", "success", "1"
      true
    when "0"
      false
    else
      false
    end
  end
end
