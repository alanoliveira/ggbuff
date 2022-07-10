# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DataLoader", type: :request do
  let(:api) { instance_double(GgxrdDotCom::Api) }

  before { allow(GgxrdDotCom::Api).to receive(:new).and_return(api) }

  describe "GET /load_matches" do
    before do
      allow(api).to receive(:profile)
    end

    context "when player is not logged in" do
      it {  expect { get "/load_matches" }.not_to(change(MatchesLoadProcess, :count)) }

      it do
        get "/load_matches"
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when the last player matches_load_process not ended" do
      include_context "with logged in player"

      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      before do
        create(:matches_load_process, player: player, state: :loading)
      end

      it { expect { get "/load_matches" }.not_to(change(MatchesLoadProcess, :count)) }

      it do
        get "/load_matches"
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when the last player matches_load_process ended" do
      include_context "with logged in player"

      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      before do
        create(:matches_load_process, player: player, state: :finished)
      end

      it do
        expect { get "/load_matches" }
          .to change(MatchesLoadProcess, :count).by(1).and have_enqueued_job(MatchesLoaderJob)
      end

      it do
        get "/load_matches"
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when the player has no last matches_load_process" do
      include_context "with logged in player"

      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      it do
        expect { get "/load_matches" }
          .to change(MatchesLoadProcess, :count).by(1).and have_enqueued_job(MatchesLoaderJob)
      end

      it do
        get "/load_matches"
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "GET /load_player" do
    before do
      allow(api).to receive(:profile).and_return(build(:ggxrd_dot_com_profile))
    end

    context "when player is not logged in" do
      it do
        get "/load_matches"

        expect(response).to redirect_to login_url
      end
    end

    context "when the player is logged in" do
      include_context "with logged in player"

      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      it do
        get "/load_player"

        expect(response).to redirect_to root_url
      end
    end
  end
end
