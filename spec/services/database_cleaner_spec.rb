# frozen_string_literal: true

require "rails_helper"

RSpec.describe DatabaseCleaner do
  let(:instance) { described_class.new }
  let(:config) do
    {
      clean_matches_older_than:           nil,
      clean_empty_matches_load_processes: nil,
      clean_players_without_matches:      nil
    }
  end

  before do
    travel_to(Time.zone.parse("2022-06-10 12:00:00"))
    allow(Rails.configuration.ggbuff).to receive(:database_cleaner).and_return(config)
  end

  describe "#run" do
    subject(:run) { instance.run }

    context "when clean_matches_older_than is set" do
      let(:num_days) { 5.days }
      let(:config) { {clean_matches_older_than: num_days.seconds} }

      before { 10.times {|i| create(:match, played_at: i.days.ago) } }

      it { expect { run }.to(change(Match, :count).by(-5)) }

      it do
        run
        expect(Match.all.map(&:played_at)).to all be > num_days.ago
      end
    end

    context "when clean_matches_older_than is not set" do
      let(:config) { {clean_matches_older_than: nil} }

      before { 10.times {|i| create(:match, played_at: i.days.ago) } }

      it { expect { run }.not_to(change(Match, :count)) }
    end

    context "when clean_empty_matches_load_processes is true" do
      let(:config) { {clean_empty_matches_load_processes: true} }

      before do
        create_list(:matches_load_process, 5, state: :finished)
        create_list(:matches_load_process, 5, :with_matches, state: :finished)
      end

      it { expect { run }.to(change(MatchesLoadProcess, :count).by(-5)) }
    end

    context "when clean_empty_matches_load_processes is false" do
      let(:config) { {clean_empty_matches_load_processes: false} }

      before do
        create_list(:matches_load_process, 5, state: :finished)
        create_list(:matches_load_process, 5, :with_matches, state: :finished)
      end

      it { expect { run }.not_to(change(MatchesLoadProcess, :count)) }
    end

    context "when clean_players_without_matches is true" do
      let(:config) { {clean_players_without_matches: true} }

      before do
        create_list(:match, 5)
        create_list(:player, 5)
      end

      it { expect { run }.to(change(Player, :count).by(-5)) }
    end

    context "when clean_players_without_matches is false" do
      let(:config) { {clean_players_without_matches: false} }

      before do
        create_list(:match, 5)
        create_list(:player, 5)
      end

      it { expect { run }.not_to(change(Player, :count)) }
    end
  end
end
