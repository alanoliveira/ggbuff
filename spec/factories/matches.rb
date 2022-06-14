# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id                    :integer          not null, primary key
#  opponent_char         :integer          not null
#  opponent_rank         :integer
#  played_at             :datetime         not null
#  player_char           :integer          not null
#  player_rank           :integer
#  rank_change           :integer
#  result                :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  match_load_process_id :integer          not null
#  opponent_id           :integer
#  player_id             :integer          not null
#  store_id              :integer          not null
#
# Indexes
#
#  index_matches_on_match_load_process_id  (match_load_process_id)
#  index_matches_on_opponent_char          (opponent_char)
#  index_matches_on_opponent_id            (opponent_id)
#  index_matches_on_opponent_rank          (opponent_rank)
#  index_matches_on_player_char            (player_char)
#  index_matches_on_player_id              (player_id)
#  index_matches_on_player_rank            (player_rank)
#  index_matches_on_result                 (result)
#  index_matches_on_store_id               (store_id)
#
# Foreign Keys
#
#  match_load_process_id  (match_load_process_id => match_load_processes.id)
#  opponent_id            (opponent_id => players.id)
#  player_id              (player_id => players.id)
#  store_id               (store_id => stores.id)
#
FactoryBot.define do
  factory :match do
    store { create(:store) }
    player { create(:player) }
    opponent { create(:player, player_name: "Rival") }
    player_char { :KY }
    opponent_char { :SO }
    player_rank { 1 }
    opponent_rank { 1 }
    result { 1 }
    rank_change { 0 }
    played_at { "2019-08-06 21:57:09" }
    match_load_process { create(:match_load_process) }
  end
end
