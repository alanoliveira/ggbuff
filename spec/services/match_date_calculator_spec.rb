# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchDateCalculator do
  let(:instance) { described_class.new(player) }
  let(:player) { create(:player) }
  let(:matches_load_process) { create(:matches_load_process) }

  before { travel_to(Time.zone.parse("2022-06-13 12:00:00")) }

  describe "#calculated" do
    subject { instance.calculate(match_date) }

    context "when it is the first match of matches_load_process" do
      context "when match m-d H:M is lesser then current date" do
        let(:match_date) { Time.zone.parse("2020-06-12 12:00:00") }
        it { is_expected.to eq Time.zone.parse("2022-06-12 12:00:00") }
      end

      context "when match m-d H:M is greather then current date" do
        let(:match_date) { Time.zone.parse("2020-06-14 12:00:00") }
        it { is_expected.to eq Time.zone.parse("2021-06-14 12:00:00") }
      end
    end

    context "when it is not the first match of matches_load_process" do
      before do
        create(:match, player: player, matches_load_process: matches_load_process, played_at: "2021-06-14 12:00:00")
      end

      context "when match m-d H:M is lesser then last match date" do
        let(:match_date) { Time.zone.parse("2020-06-12 12:00:00") }
        it { is_expected.to eq Time.zone.parse("2021-06-12 12:00:00") }
      end

      context "when match m-d H:M is greather then last match date" do
        let(:match_date) { Time.zone.parse("2020-06-15 12:00:00") }
        it { is_expected.to eq Time.zone.parse("2020-06-15 12:00:00") }
      end
    end
  end
end
