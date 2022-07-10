# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id            :bigint           not null, primary key
#  player_name   :string           default("GG PLAYER")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ggxrd_user_id :integer          not null
#
# Indexes
#
#  index_players_on_ggxrd_user_id  (ggxrd_user_id) UNIQUE
#  index_players_on_player_name    (player_name)
#
FactoryBot.define do
  factory :player do
    sequence(:ggxrd_user_id, 1000) {|n| n }
    sequence(:player_name, 1000) {|n| "GG PLAYER #{n}" }
  end
end
