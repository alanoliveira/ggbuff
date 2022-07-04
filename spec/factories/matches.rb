# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id                      :bigint           not null, primary key
#  opponent_char           :integer          not null
#  opponent_rank           :integer
#  played_at               :datetime         not null
#  player_char             :integer          not null
#  player_rank             :integer
#  rank_change             :integer
#  result                  :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  matches_load_process_id :bigint           not null
#  opponent_id             :bigint
#  player_id               :bigint           not null
#  store_id                :bigint           not null
#
# Indexes
#
#  index_matches_on_matches_load_process_id  (matches_load_process_id)
#  index_matches_on_opponent_char            (opponent_char)
#  index_matches_on_opponent_id              (opponent_id)
#  index_matches_on_opponent_rank            (opponent_rank)
#  index_matches_on_player_char              (player_char)
#  index_matches_on_player_id                (player_id)
#  index_matches_on_player_rank              (player_rank)
#  index_matches_on_result                   (result)
#  index_matches_on_store_id                 (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (matches_load_process_id => matches_load_processes.id)
#  fk_rails_...  (opponent_id => players.id)
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (store_id => stores.id)
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
    rank_change { nil }
    sequence(:played_at) {|n| (15 * n).minutes.ago }
    matches_load_process { create(:matches_load_process, player: player) }
  end
end
