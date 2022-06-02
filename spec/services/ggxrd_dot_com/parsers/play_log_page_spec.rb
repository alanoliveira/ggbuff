# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::PlayLogPage do
  describe "#play_logs" do
    subject { described_class.new(html).play_logs }

    context "when html file has a list of playlogs", :aggregate_failures do
      let(:html) do
        <<-HTML
            <div>
              <div class="playLog"></div>
              <div class="playLog"></div>
              <div class="playLog"></div>
            </div>
        HTML
      end

      it { is_expected.to have(3).items.and all(be_a(GgxrdDotCom::Parsers::PlayLogDiv)) }
    end

    context "when passed html file not has a list of playlogs" do
      let(:html) do
        <<-HTML.chomp
        <div></div>
        HTML
      end

      it { is_expected.to be_empty }
    end
  end
end
