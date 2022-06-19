# frozen_string_literal: true

module ApplicationHelper
  def flash_alert_class(type)
    case type.to_s
    when "notice"  then "alert-secondary"
    when "error"   then "alert-danger"
    else "alert-#{level}"
    end
  end
end
