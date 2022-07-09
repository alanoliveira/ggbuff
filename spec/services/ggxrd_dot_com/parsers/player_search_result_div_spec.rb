# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::PlayerSearchResultDiv do
  let(:node) { Nokogiri::HTML::DocumentFragment.parse(html).elements.first }

  describe "#url" do
    subject { described_class.new(node).url }

    let(:html) { "<div class='searchResultList'><a href='#{url}'>GG PLAYER</a></div>" }

    context "when url exists" do
      let(:url) { "member_profile_view.php?user_id=222" }

      it { is_expected.to eq(url) }
    end

    context "when url is blank" do
      let(:url) { "" }

      it { is_expected.to eq("") }
    end

    include_examples "unexpected html structure", "<div><span>GG PLAYER</span></div>"
  end

  describe "#player_name" do
    subject { described_class.new(node).player_name }

    let(:html) { "<div class='searchResultList'><a href='http://foo/bar'>#{player_name}</a></div>" }

    context "when player_name exists" do
      let(:player_name) { "GG BAIKEN PLAYER" }

      it { is_expected.to eq(player_name) }
    end

    context "when player_name is blank" do
      let(:player_name) { "" }

      it { is_expected.to eq("") }
    end

    include_examples "unexpected html structure", "<div><span>GG PLAYER</span></div>"
  end
end
