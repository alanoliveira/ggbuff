# frozen_string_literal: true

FactoryBot.define do
  factory :ggxrd_dot_com_player_search, class: GgxrdDotCom::Models::PlayerSearch do
    results { [] }

    initialize_with { new(attributes) }

    trait :with_results do
      transient do
        results_count { 5 }
      end

      results { results_count.times.map { build(:ggxrd_dot_com_player_search_result) } }
    end
  end

  factory :ggxrd_dot_com_player_search_result, class: GgxrdDotCom::Models::PlayerSearch::Result do
    sequence(:player_name, "GG PLAYER 1")
    sequence(:profile_url, "member_profile_view.php?user_id=11111")

    initialize_with { new(attributes) }
  end
end
