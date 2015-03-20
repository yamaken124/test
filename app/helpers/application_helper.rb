module ApplicationHelper

  def number_to_jpy(numeric)
    number_to_currency(numeric, unit: '', precision: 0)
  end

end
