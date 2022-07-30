# frozen_string_literal: true

module ApplicationHelper
  def flash_alert_class(type)
    t = case type
        when "error" then "danger"
        else type
        end
    "alert-#{t}"
  end
end
