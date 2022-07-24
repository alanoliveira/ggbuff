# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::AimeSelectionAnchor do
  let(:node) { Nokogiri::HTML::DocumentFragment.parse(html).elements.first }

  describe "#url" do
    subject { described_class.new(node).url }

    let(:html) { "<a href='#{url}'>Aime1<br>11111111111111111111</a>" }

    context "when url exists" do
      let(:url) { "aime_key=222" }

      it { is_expected.to eq(url) }
    end

    context "when url is blank" do
      let(:url) { "" }

      it { is_expected.to eq("") }
    end
  end

  describe "#name" do
    subject { described_class.new(node).name }

    let(:html) { "<a href='aime_key=222'>#{name}<br>22222222222222222222</a>" }

    context "when name exists" do
      let(:name) { "Aime1" }

      it { is_expected.to eq(name) }
    end

    context "when name is blank" do
      let(:name) { "" }

      it { is_expected.to eq("") }
    end
  end
end
