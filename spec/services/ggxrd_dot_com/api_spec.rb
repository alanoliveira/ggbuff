# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Api do
  let(:instance) { described_class.new(cli) }
  let(:cli) { instance_double(GgxrdDotCom::Client) }

  shared_context "when ggxrd.com return a non 200 response" do
    context do
      let(:response) { Net::HTTPInternalServerError.new(1.0, "500", "Internal Server Error") }
      it { expect { subject }.to raise_error GgxrdDotCom::Api::ApiError }
    end
  end

  describe "#login" do
    subject { instance.login("user", "password") }
    let(:response) { Net::HTTPFound.new(1.0, "302", "Found") }

    before do
      allow(response).to receive(:body)
      allow(cli).to receive(:login).and_return(response)
    end

    it { is_expected.to be_a(GgxrdDotCom::Values::LoginResult) }
  end

  describe "#my_id?" do
    subject { instance.my_id?(1) }
    let(:response) { Net::HTTPFound.new(1.0, "302", "Found") }

    before { allow(cli).to receive(:member_profile_view).and_return(response) }

    it { is_expected.to be true }

    context "when it is not" do
      let(:response) { Net::HTTPOK.new(1.0, "200", "OK") }

      it { is_expected.to be false }
    end
  end

  describe "#profile" do
    subject { instance.profile }
    let(:response) { Net::HTTPOK.new(1.0, "200", "OK") }
    let(:profile) { build(:ggxrd_dot_com_profile) }

    before do
      allow(response).to receive(:body)
      allow(cli).to receive(:profile).and_return(response)
      allow(GgxrdDotCom::Parsers::ProfilePage).to receive(:new)
      allow(GgxrdDotCom::Values::Profile).to receive(:new).and_return(profile)
      allow(profile).to receive(:populate)
    end

    it { is_expected.to be_a(GgxrdDotCom::Values::Profile) }

    include_context "when ggxrd.com return a non 200 response"
  end

  describe "#matches" do
    subject { instance.matches }
    let(:response) { Net::HTTPOK.new(1.0, "200", "OK") }
    let(:play_log) { build(:ggxrd_dot_com_play_log) }

    before do
      allow(response).to receive(:body)
      allow(cli).to receive(:play_log).and_return(response)
      allow(GgxrdDotCom::Parsers::PlayLogPage).to receive(:new)
      allow(GgxrdDotCom::Values::PlayLog).to receive(:new).and_return(play_log)
      allow(play_log).to receive(:populate)
    end

    it { is_expected.to be_a(GgxrdDotCom::Values::PlayLog) }

    include_context "when ggxrd.com return a non 200 response"
  end

  describe "#search_player" do
    subject { instance.search_player("GG Player") }
    let(:response) { Net::HTTPOK.new(1.0, "200", "OK") }
    let(:player_search) { build(:ggxrd_dot_com_player_search) }

    before do
      allow(response).to receive(:body)
      allow(cli).to receive(:player_search).and_return(response)
      allow(GgxrdDotCom::Parsers::PlayerSearchPage).to receive(:new)
      allow(GgxrdDotCom::Values::PlayerSearch).to receive(:new).and_return(player_search)
      allow(player_search).to receive(:populate)
    end

    it { is_expected.to be_a(GgxrdDotCom::Values::PlayerSearch) }

    include_context "when ggxrd.com return a non 200 response"
  end
end
