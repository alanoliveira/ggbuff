# frozen_string_literal: true

FactoryBot.define do
  factory :ggxrd_dot_com_play_log, class: GgxrdDotCom::Values::PlayLog do
    logs { [] }

    initialize_with { new(attributes) }

    trait :with_logs do
      transient do
        logs_count { 5 }
      end

      logs { logs_count.times.map { build(:ggxrd_dot_com_play_log_log) } }
    end
  end

  factory :ggxrd_dot_com_play_log_log, class: GgxrdDotCom::Values::PlayLog::Log do
    result { GgxrdDotCom::Values::Enums::PLAY_LOG_RESULTS.keys.sample }
    rank_change { GgxrdDotCom::Values::Enums::PLAY_LOG_RANK_DIRECTIONS.keys.push(nil).sample }
    player_rank { GgxrdDotCom::Values::Enums::RANKS.keys.sample }
    opponent_rank { GgxrdDotCom::Values::Enums::RANKS.keys.sample }
    player_char { GgxrdDotCom::Values::Enums::CHAR_NAMES.keys.sample }
    opponent_char { GgxrdDotCom::Values::Enums::CHAR_NAMES.keys.sample }
    sequence(:play_date) {|n|
      (n * 5).minutes.ago.strftime("#{GgxrdDotCom::Values::PlayLog::Log::DUMMY_PLAY_DATE_YEAR}/%m/%d %H:%M")
    }
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
