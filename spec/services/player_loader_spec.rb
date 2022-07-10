# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlayerLoader do
  let(:instance) { described_class.new(api) }
  let(:api) { instance_double(GgxrdDotCom::Api) }

  describe "#load_player" do
    subject(:load_player) { instance.load_player(my_ggxrd_id) }

    let(:my_ggxrd_id) { "5" }
    let(:my_player_name) { "Baiken Player" }

    before do
      allow(api).to receive(:profile).and_return(build(:ggxrd_dot_com_profile, player_name: my_player_name))
    end

    context "when the player changed the name" do
      let!(:player) { create(:player, ggxrd_user_id: my_ggxrd_id, player_name: "Ky Player") }

      it { expect { load_player }.to(change { player.reload.player_name }) }

      it do
        load_player
        expect(Player.where(player_name: my_player_name, ggxrd_user_id: my_ggxrd_id)).to exist
      end
    end
  end
end
