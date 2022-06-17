# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesLoader do
  let(:instance) { described_class.new(match_load_process) }
  let(:api) { instance_double(GgxrdDotCom::Api) }
  let(:match_load_process) { create(:match_load_process, ggxrd_dot_com_api: api) }

  describe "#load_matches" do
    subject { instance.load_matches }
    let(:logs_count) { 10 }
    let(:play_log) {
      build(:ggxrd_dot_com_play_log,
            :with_logs,
            logs_count: logs_count)
    }

    before do
      allow(api).to receive(:matches).with(1).and_return(play_log)
      allow(api).to receive(:matches).with(2).and_return(build(:ggxrd_dot_com_play_log))
    end

    context "when there is new matches" do
      it do
        expect { subject }.to change { Match.count }.by(logs_count)
      end
    end

    context "when there is no new matches" do
      before do
        subject
      end

      it do
        expect { subject }.not_to(change { Match.count })
      end
    end

    context "when some error occur during the loading" do
      before { allow(api).to receive(:matches).with(2).and_raise(GgxrdDotCom::Parsers::Error) }

      it do
        expect { subject }.to(raise_error(GgxrdDotCom::Parsers::Error).and(not_change { Match.count }))
      end
    end
  end
end
