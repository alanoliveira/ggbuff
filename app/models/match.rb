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
  enum result: {win: 1, lose: 0}
  enum rank_change: {rank_up: 1, rank_down: -1}

  delegate :name, to: :player, prefix: true
  delegate :name, to: :opponent, prefix: true
  delegate :name, to: :store, prefix: true

  scope :rivals, ->(limit=5) { MatchRivals.new(self).search(limit: limit) }
  scope :victims, ->(limit=5) { MatchVictims.new(self).search(limit: limit) }
  scope :tormentors, ->(limit=5) { MatchTormentors.new(self).search(limit: limit) }
end
