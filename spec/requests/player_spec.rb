# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Indices", type: :request do
  describe "GET /matches" do
    context "when player is not logged in" do
      it do
        get "/matches"
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when player is logged in" do
      include_context "with logged in player"
      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      before do
        create(:matches_load_process, :with_matches, player: player, matches_count: 5)
        create(:matches_load_process, :with_matches, matches_count: 5)
      end

      it do
        get "/matches"

        doc = Nokogiri::HTML(response.body)
        expect(doc.xpath("//table[@id='match-search-result-table']/tbody/tr").length).to eq 5
      end
    end
  end

  describe "GET /load_matches" do
    before { allow_any_instance_of(GgxrdDotCom::Api).to receive(:profile) }

    context "when player is not logged in" do
      it do
        expect { get "/load_matches" }.not_to(change { MatchesLoadProcess.count })
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

      it do
        expect { get "/load_matches" }.not_to(change { MatchesLoadProcess.count })
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
          .to change { MatchesLoadProcess.count }.by(1).and have_enqueued_job(MatchesLoaderJob)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when the player has no last matches_load_process" do
      include_context "with logged in player"

      let(:player) { create(:player) }
      let(:player_to_log_in) { player }

      it do
        expect { get "/load_matches" }
          .to change { MatchesLoadProcess.count }.by(1).and have_enqueued_job(MatchesLoaderJob)
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
