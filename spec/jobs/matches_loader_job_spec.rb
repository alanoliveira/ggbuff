# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchesLoaderJob, type: :job do
  describe "#perform" do
    subject { described_class.new.perform(matches_load_process.id, "") }
    let(:matches_load_process) { create(:matches_load_process) }

    before do
      allow(GgxrdApi).to receive(:new)
      allow(MatchesLoadProcess).to receive(:find).with(matches_load_process.id).and_return matches_load_process
      allow(matches_load_process).to receive(:load!)
      allow(matches_load_process).to receive(:finish!)
    end

    it do
      subject
      expect(matches_load_process).to have_received(:load!)
      expect(matches_load_process).to have_received(:finish!)
    end

    context "when some error happens during loading process" do
      before do
        allow(matches_load_process).to receive(:load!).and_raise StandardError
      end

      it do
        expect { subject }.to change { matches_load_process.reload.state }.to("error")
      end
    end
  end
end
