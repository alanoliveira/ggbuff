# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id            :bigint           not null, primary key
#  last_login_at :datetime
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
class Player < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :matches_load_processes, dependent: :destroy

  alias_attribute :name, :player_name

  def update_last_login_at
    update(last_login_at: Time.zone.now)
  end
end
