# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdApi do
  let(:api) { instance_double(GgxrdDotCom::Api) }
  let(:instance) { described_class.new }

  before do
    allow(GgxrdDotCom::Client).to receive(:new)
    allow(GgxrdDotCom::Api).to receive(:new).and_return(api)
  end

  describe "#fetch_ggxrd_user_id" do
    subject(:load_player) { instance.fetch_ggxrd_user_id }

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

    context "when ggxrd_user_id is found" do
      it { is_expected.to eq my_ggxrd_id }
    end

    context "when player ggxrd_user_id can not be found" do
      let(:my_search_player_result) { nil }

      it do
        expect { load_player }.to raise_error(GgxrdApi::UserIdNotFoundError)
      end
    end
  end
end
