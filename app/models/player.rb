# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  player_name   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ggxrd_user_id :integer          not null
#
# Indexes
#
#  index_players_on_ggxrd_user_id  (ggxrd_user_id) UNIQUE
#  index_players_on_player_name    (player_name)
#
class Player < ApplicationRecord
  has_many :matches, dependent: :destroy
end
