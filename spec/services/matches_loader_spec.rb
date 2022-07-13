# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesLoader do
  let(:api) { instance_double(GgxrdDotCom::Api) }
  let(:player) { create(:player) }
  let(:matches_load_process) { create(:matches_load_process, player: player, ggxrd_api: api) }

  describe "#load_matches" do
    subject(:load_matches) { described_class.new(matches_load_process).load_matches }

    let(:logs_count) { 3 }
    let(:play_log) { build(:ggxrd_dot_com_play_log, :with_logs, logs_count: logs_count) }

    before do
      allow(api).to receive(:matches).with(1).and_return(play_log)
      allow(api).to receive(:matches).with(2).and_return(build(:ggxrd_dot_com_play_log))
    end

    context "when there is new matches" do
      it do
        expect { load_matches }.to change(Match, :count).by(logs_count)
      end
    end

    context "when there is no new matches" do
      before do
        other_matches_load_process = create(:matches_load_process, player: player, ggxrd_api: api)
        described_class.new(other_matches_load_process).load_matches
      end

      it do
        expect { load_matches }.not_to(change(Match, :count))
      end
    end

    context "when skip_older_than is set and there are old matches" do
      before do
        play_log.logs.each_with_index do |l, i|
          l.play_date = (i * 5).days.ago.strftime("%m/%d %H:%M")
        end

        allow(Rails.configuration.ggbuff.matches_loader)
          .to receive(:[])
          .with(:skip_older_than)
          .and_return(3.days.seconds)
      end

      it do
        expect { load_matches }.to(change(Match, :count).by(1))
      end
    end

    context "when some error occur during the loading" do
      before { allow(api).to receive(:matches).with(2).and_raise(GgxrdDotCom::Parsers::Error) }

      it do
        expect { load_matches }.to(raise_error(GgxrdDotCom::Parsers::Error).and(not_change { Match.count }))
      end
    end
  end
end
