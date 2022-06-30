# frozen_string_literal: true

module PlayerHelper
  def rank_change_icon(rank_change)
    return rank_up_icon if rank_change == "rank_up"
    return rank_down_icon if rank_change == "rank_down"
  end

  def match_result_badge(match_result)
    bg_class = match_result == "win" ? "bg-success" : "bg-danger"
    content_tag(:span, Match.human_enum_name(:result, match_result), class: "badge #{bg_class}")
  end

  private

  def rank_up_icon
    content_tag(:i, nil, class: "fa-solid fa-arrow-up text-primary mx-2", title: "rank up")
  end

  def rank_down_icon
    content_tag(:i, nil, {class: "fa-solid fa-arrow-down text-danger mx-2", title: "rank down"})
  end
end
