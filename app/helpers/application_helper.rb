module ApplicationHelper

  # def readable_date(date)
  #   return "[unknown]" unless date
  #   return content_tag(:span, "#{date_voted_on(date)}", class: 'date', title: date.to_s)
  # end
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-warning" }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_messages
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert"))
    end
    nil
  end

end
