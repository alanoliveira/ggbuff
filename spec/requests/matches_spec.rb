# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Matches", type: :request do
  let(:api) { instance_double(GgxrdDotCom::Api) }

  before { allow(GgxrdDotCom::Api).to receive(:new).and_return(api) }

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
end
