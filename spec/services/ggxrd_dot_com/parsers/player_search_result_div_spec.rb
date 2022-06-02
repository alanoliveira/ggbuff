# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::PlayerSearchResultDiv do
  describe "#url" do
    subject { described_class.new(node).url }
    let(:node) { Nokogiri::HTML::DocumentFragment.parse(html) }
    let(:html) { "<div class='searchResultList'><a href='#{url}'>GG PLAYER</a></div>" }

    context "when url exists" do
      let(:url) { "member_profile_view.php?user_id=222" }
      it { is_expected.to eq(url) }
    end

    context "when url is blank" do
      let(:url) { "" }
      it { is_expected.to eq("") }
    end

    include_examples "unexpected html structure", "<div><a href='foo/bar'>GG PLAYER</a></div>"
  end

  describe "#name" do
    subject { described_class.new(node).name }
    let(:node) { Nokogiri::HTML::DocumentFragment.parse(html) }
    let(:html) { "<div class='searchResultList'><a href='http://foo/bar'>#{name}</a></div>" }

    context "when name exists" do
      let(:name) { "GG BAIKEN PLAYER" }
      it { is_expected.to eq(name) }
    end

    context "when name is blank" do
      let(:name) { "" }
      it { is_expected.to eq("") }
    end

    include_examples "unexpected html structure", "<div><a href='foo/bar'>GG PLAYER</a></div>"
  end
end
