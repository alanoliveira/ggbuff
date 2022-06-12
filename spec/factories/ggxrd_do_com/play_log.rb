# frozen_string_literal: true

FactoryBot.define do
  factory :ggxrd_dot_com_play_log, class: GgxrdDotCom::Models::PlayLog do
    logs { [] }

    initialize_with { new(attributes) }

    trait :with_logs do
      transient do
        logs_count { 5 }
      end

      logs { logs_count.times.map { build(:ggxrd_dot_com_play_log_log) } }
    end
  end

  factory :ggxrd_dot_com_play_log_log, class: GgxrdDotCom::Models::PlayLog::Log do
    result { GgxrdDotCom::Models::PlayLog::Log::RESULTS.keys.sample }
    rank_change { GgxrdDotCom::Models::PlayLog::Log::RANK_DIRECTIONS.keys.push(nil).sample }
    player_rank { GgxrdDotCom::Models::Enums::RANKS.keys.sample }
    opponent_rank { GgxrdDotCom::Models::Enums::RANKS.keys.sample }
    player_char { GgxrdDotCom::Models::Enums::CHAR_NAMES.keys.sample }
    opponent_char { GgxrdDotCom::Models::Enums::CHAR_NAMES.keys.sample }
    sequence(:play_date) {|n| n.minutes.ago.strftime("%m/%d %H:%M") }
    shop_name { "My House Game Center" }
    opponent_rand = [1, 2].sample
    opponent_name { "GG PLAYER #{opponent_rand}" }
    opponent_profile_url { "member_profile_view.php?user_id=#{opponent_rand}" }

    trait :with_non_logged_opponent do
      opponent_rank { nil }
      opponent_name { nil }
      opponent_profile_url { nil }
    end

    initialize_with { new(attributes) }
  end
end
