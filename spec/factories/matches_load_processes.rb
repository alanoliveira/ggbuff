# frozen_string_literal: true

# == Schema Information
#
# Table name: matches_load_processes
#
#  id                :bigint           not null, primary key
#  error_description :string
#  state             :integer          default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  player_id         :bigint           not null
#
# Indexes
#
#  index_matches_load_processes_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#
FactoryBot.define do
  factory :matches_load_process do
    state { :created }
    player { create(:player) }

    trait :with_matches do
      transient do
        matches_count { 5 }
      end

      matches {
        Array.new(matches_count) { create(:match, player: player, matches_load_process: instance) }
      }
    end
  end
end
