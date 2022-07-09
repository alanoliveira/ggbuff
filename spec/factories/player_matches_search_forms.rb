# frozen_string_literal: true

FactoryBot.define do
  factory :player_matches_search_form, class: "PlayerMatchesSearchForm" do
    player_char { nil }
    player_rank_min { nil }
    player_rank_max { nil }
    opponent_name { nil }
    opponent_name_partial { nil }
    opponent_char { nil }
    opponent_rank_min { nil }
    opponent_rank_max { nil }
    played_at_from { nil }
    played_at_to { nil }

    transient do
      player { create(:player) }
    end

    initialize_with { new(player, attributes) }
  end
end
