# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlayerLoader do
  let(:instance) { described_class.new(api) }
  let(:api) { instance_double(GgxrdDotCom::Api) }

  describe "#load_player" do
    subject(:load_player) { instance.load_player }

    let(:my_ggxrd_id) { "5" }
    let(:my_player_name) { "Baiken Player" }
    let(:my_search_player_result) do
      build(
        :ggxrd_dot_com_player_search_result,
        player_name: my_player_name,
        profile_url: "member_profile_view.php?user_id=#{my_ggxrd_id}"
      )
    end

    before do
      allow(api).to receive(:profile).and_return(build(:ggxrd_dot_com_profile, player_name: my_player_name))
      player_search = build(:ggxrd_dot_com_player_search, :with_results)
      player_search.results << my_search_player_result if my_search_player_result.present?
      allow(api).to receive(:search_player).and_return(player_search)
      allow(api).to receive(:my_id?).and_return(false)
      allow(api).to receive(:my_id?).with(my_ggxrd_id).and_return(true)
    end

    context "when it is a new player" do
      it { expect { load_player }.to change(Player, :count).by(1) }

      it do
        load_player
        expect(Player.where(player_name: my_player_name, ggxrd_user_id: my_ggxrd_id)).to exist
      end
    end

    context "when the player already exists, but changed the name" do
      before { create(:player, ggxrd_user_id: my_ggxrd_id, player_name: "Ky Player") }

      it { expect { load_player }.not_to(change(Player, :count)) }

      it do
        load_player
        expect(Player.where(player_name: my_player_name, ggxrd_user_id: my_ggxrd_id)).to exist
      end
    end

    context "when player ggxrd_user_id can not be found" do
      let(:my_search_player_result) { nil }

      it do
        expect { load_player }.to raise_error(PlayerLoader::UserIdNotFoundError).and(not_change { Player.count })
      end
    end
  end
end
