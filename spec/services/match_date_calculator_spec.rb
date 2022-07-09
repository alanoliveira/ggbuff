# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchDateCalculator do
  let(:instance) { described_class.new }

  before { travel_to(Time.zone.parse("2022-06-13 12:00:00")) }

  describe "#calculated" do
    subject { instance.calculate(match_date) }

    before { instance.instance_variable_set(:@base_date, Time.zone.parse("2021-06-14 12:00:00")) }

    context "when match m-d H:M is lesser then the base_date" do
      let(:match_date) { Time.zone.parse("2020-06-12 12:00:00") }

      it { is_expected.to eq Time.zone.parse("2021-06-12 12:00:00") }
    end

    context "when match m-d H:M is greather then the base_date" do
      let(:match_date) { Time.zone.parse("2020-06-15 12:00:00") }

      it { is_expected.to eq Time.zone.parse("2020-06-15 12:00:00") }
    end

    context "when match m-d H:M is equal the base_date" do
      let(:match_date) { Time.zone.parse("2020-06-14 12:00:00") }

      it { is_expected.to eq Time.zone.parse("2020-06-14 12:00:00") }
    end
  end
end
