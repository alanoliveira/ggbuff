# frozen_string_literal: true

# == Schema Information
#
# Table name: matches_load_processes
#
#  id                :integer          not null, primary key
#  error_description :string
#  state             :integer          default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  player_id         :integer          not null
#
# Indexes
#
#  index_matches_load_processes_on_player_id  (player_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#
class MatchesLoadProcess < ApplicationRecord
  include AASM
  belongs_to :player
  attr_accessor :ggxrd_dot_com_api

  enum state: {created: 0, loading: 10, error: 90, finished: 100}

  aasm column: :state, enum: true, use_transactions: false do
    state :created, initial: true
    state :loading
    state :error
    state :finished

    error_on_all_events { update!(state: :error) }

    event :load do
      after do
        MatchesLoader.new(self).load_matches
      end

      transitions from: :created, to: :loading, guard: -> { ggxrd_dot_com_api.present? }
    end

    event :finish do
      transitions from: :loading, to: :finished
    end
  end
end
