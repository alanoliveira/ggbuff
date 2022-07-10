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
  before do
    allow(mocked_api).to receive(:login).and_return(GgxrdDotCom::Values::LoginResult.new)
    allow(mocked_api).to receive(:fetch_ggxrd_user_id).and_return(player_to_log_in.ggxrd_user_id)
    allow(mocked_api).to receive(:select_aime).and_return(true)
  end
end
