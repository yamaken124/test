module ApplicationHelper

  def number_to_jpy(numeric)
    "￥#{number_to_currency(numeric, unit: '', precision: 0)}"
  end

  def include_line_break(text)
    return text if text.blank?
    sanitize text.gsub(/\r\n|\r|\n/, "<br />"), :tag => %w(br)
  end

  def show_only_main?
    params[:name] == 'tutorial'
  end

end
