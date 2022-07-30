# frozen_string_literal: true

require "rails_helper"

RSpec.describe DatabaseCleaner do
  let(:instance) { described_class.new }
  let(:config) { {old_data_threshold: nil} }

  before do
    travel_to(Time.zone.parse("2022-06-10 12:00:00"))
    allow(Rails.configuration.ggbuff).to receive(:database_cleaner).and_return(config)
  end

  describe "#run" do
    subject(:run) { instance.run }

    let(:config) { {old_data_threshold: 1.month.seconds} }

    it "clean old matches" do
      (-5..5).each {|i| create(:match, played_at: (1.month.ago + i.days)) }

      expect { run }
        .to change(Match.where(played_at: ..1.month.ago), :count).by(-6)
        .and not_change(Match.where(played_at: (1.month - 1.second).ago..), :count)
    end

    it "clean old matches_load_processes" do
      (-5..5).each {|i| create(:matches_load_process, created_at: (1.month.ago + i.days)) }

      expect { run }
        .to change(MatchesLoadProcess.where(created_at: ..1.month.ago), :count).by(-6)
        .and not_change(MatchesLoadProcess.where(created_at: (1.month - 1.second).ago..), :count)
    end

    it "clean inactive players without matches" do
      create(:player, last_login_at: 1.month.ago)
      create(:player, last_login_at: 1.day.ago)
      create(:match, player:   create(:player, last_login_at: 1.day.ago),
                     opponent: create(:player, last_login_at: 1.month.ago))

      expect { run }.to change(Player, :count).by(-1)
    end

    context "when old_data_threshold is nil" do
      let(:config) { {old_data_threshold: nil} }

      before do
        (-5..5).each do |i|
          create(:match, played_at: (1.month.ago + i.days))
          create(:matches_load_process, created_at: (1.month.ago + i.days))
        end

        create(:player, last_login_at: 1.month.ago)
        create(:player, last_login_at: 1.day.ago)
        create(:match, player:   create(:player, last_login_at: 1.day.ago),
                       opponent: create(:player, last_login_at: 1.month.ago))
      end

      it { expect { run }.not_to change(Match, :count) }
      it { expect { run }.not_to change(MatchesLoadProcess, :count) }
      it { expect { run }.not_to change(Player, :count) }
    end
  end
end
