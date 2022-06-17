# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id                      :integer          not null, primary key
#  opponent_char           :integer          not null
#  opponent_rank           :integer
#  played_at               :datetime         not null
#  player_char             :integer          not null
#  player_rank             :integer
#  rank_change             :integer
#  result                  :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  matches_load_process_id :integer          not null
#  opponent_id             :integer
#  player_id               :integer          not null
#  store_id                :integer          not null
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
#  matches_load_process_id  (matches_load_process_id => matches_load_processes.id)
#  opponent_id              (opponent_id => players.id)
#  player_id                (player_id => players.id)
#  store_id                 (store_id => stores.id)
#
class Match < ApplicationRecord
  belongs_to :store
  belongs_to :player
  belongs_to :opponent,
             class_name: "Player",
             optional:   true
  belongs_to :matches_load_process

  default_scope { order(played_at: :desc) }
  enum player_char: Enums::CHARACTERS, _prefix: true
  enum opponent_char: Enums::CHARACTERS, _prefix: true
  enum result: {win: 1, lose: -1}
end
