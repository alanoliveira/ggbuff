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
require "rails_helper"

RSpec.describe Player do
  describe "#update_last_login_at" do
    subject(:update_last_login_at) { instance.update_last_login_at }

    let(:instance) { create(:player, last_login_at: 1.week.ago) }

    it do
      expect { update_last_login_at }.to change { instance.reload.last_login_at }
        .to(a_value_within(1.minute).of(Time.zone.now))
    end
  end
end
