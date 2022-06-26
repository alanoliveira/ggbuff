# frozen_string_literal: true

require "rails_helper"

RSpec.shared_context "with mocked ggxrd_api" do
  let(:mocked_api) { spy }

  before do
    allow(GgxrdApi).to receive(:new).and_return(mocked_api)
    allow(mocked_api).to receive(:cookies).and_return("xxyyzz")
  end
end

RSpec.shared_context "with mocked api login methods" do
  include_context "with mocked ggxrd_api"
  let(:player_to_log_in) { create(:player) }
  let(:player_to_log_in_profile) { build(:ggxrd_dot_com_profile, player_name: player_to_log_in.player_name) }
  let(:player_to_log_in_search_result) do
    build(
      :ggxrd_dot_com_player_search,
      results: [
        build(
          :ggxrd_dot_com_player_search_result,
          player_name: player_to_log_in.player_name,
          profile_url: "member_profile_view.php?user_id=#{player_to_log_in.ggxrd_user_id}"
        )
      ]
    )
  end
  before do
    allow(mocked_api).to receive(:login).and_return(GgxrdDotCom::Values::LoginResult.new)
    allow(mocked_api).to receive(:profile).and_return(player_to_log_in_profile)
    allow(mocked_api).to receive(:search_player)
      .with(player_to_log_in.player_name, 1)
      .and_return(player_to_log_in_search_result)
  end
end
