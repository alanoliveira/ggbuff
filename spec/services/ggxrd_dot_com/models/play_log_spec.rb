# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::PlayLog::Log do
  let(:instance) { described_class.new }

  describe ".create" do
    subject do
      described_class.create(
        instance_double(
          GgxrdDotCom::Parsers::PlayLogDiv,
          opponent_rank:        "",
          node:                 "",
          opponent_char:        "",
          player_char:          "",
          play_date:            "",
          shop_name:            "",
          opponent_profile_url: "",
          result:               "",
          opponent_name:        "",
          icon_status_image:    "",
          player_rank:          ""
        )
      )
    end

    it { is_expected.to be_a(described_class) }
  end

  describe "#result=" do
    subject { instance.result = val }
    before { instance.instance_variable_set(:@result, Object.new) }

    context "when value is 'win'" do
      let(:val) { "win" }
      it { expect { subject }.to change { instance.result }.to(:win) }
    end

    context "when value is 'lose'" do
      let(:val) { "lose" }
      it { expect { subject }.to change { instance.result }.to(:lose) }
    end

    context "when value is unexpected" do
      let(:val) { "draw" }
      it { expect { subject }.to change { instance.result }.to(nil) }
    end
  end

  describe "#ranking_change=" do
    subject { instance.rank_change = val }
    before { instance.instance_variable_set(:@rank_change, Object.new) }

    context "when value is 'img/rank_up.png'" do
      let(:val) { "img/rank_up.png" }
      it { expect { subject }.to change { instance.rank_change }.to(:rank_up) }
    end

    context "when value is 'img/rank_down.png'" do
      let(:val) { "img/rank_down.png" }
      it { expect { subject }.to change { instance.rank_change }.to(:rank_down) }
    end

    context "when value is nil" do
      let(:val) { nil }
      it { expect { subject }.to change { instance.rank_change }.to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "draw" }
      it { expect { subject }.to change { instance.rank_change }.to(nil) }
    end
  end

  describe "#opponent_rank=" do
    subject { instance.opponent_rank = val }
    before { instance.instance_variable_set(:@opponent_rank, Object.new) }

    context "when value is '25段'" do
      let(:val) { "25段" }
      it { expect { subject }.to change { instance.opponent_rank }.to(25) }
    end

    context "when value is nil" do
      let(:val) { nil }
      it { expect { subject }.to change { instance.opponent_rank }.to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "godlike" }
      it { expect { subject }.to change { instance.opponent_rank }.to(nil) }
    end
  end

  describe "#player_char=" do
    subject { instance.player_char = val }
    before { instance.instance_variable_set(:@player_char, Object.new) }

    context "when value is '梅喧'" do
      let(:val) { "梅喧" }
      it { expect { subject }.to change { instance.player_char }.to(:BA) }
    end

    context "when value is nil" do
      let(:val) { nil }
      it { expect { subject }.to change { instance.player_char }.to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "テスタメント" }
      it { expect { subject }.to change { instance.player_char }.to(nil) }
    end
  end

  describe "#opponent_char=" do
    subject { instance.opponent_char = val }
    before { instance.instance_variable_set(:@opponent_char, Object.new) }

    context "when value is 'カイ'" do
      let(:val) { "カイ" }
      it { expect { subject }.to change { instance.opponent_char }.to(:KY) }
    end

    context "when value is nil" do
      let(:val) { nil }
      it { expect { subject }.to change { instance.opponent_char }.to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "ザッパ" }
      it { expect { subject }.to change { instance.opponent_char }.to(nil) }
    end
  end
end
