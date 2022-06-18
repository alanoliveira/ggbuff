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
FactoryBot.define do
  factory :matches_load_process do
    state { :created }
    player { create(:player) }
  end
end
