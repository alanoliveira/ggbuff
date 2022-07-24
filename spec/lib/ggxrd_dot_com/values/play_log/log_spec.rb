# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Values::PlayLog::Log do
  let(:instance) { described_class.new }

  describe "#result=" do
    subject(:set_result) { instance.result = val }

    context "when value is 'win'" do
      let(:val) { "win" }

      it { expect { set_result }.to change(instance, :result).to(:win) }
    end

    context "when value is 'lose'" do
      let(:val) { "lose" }

      it { expect { set_result }.to change(instance, :result).to(:lose) }
    end

    context "when value is unexpected" do
      let(:val) { "draw" }

      before { instance.result = "win" }

      it { expect { set_result }.to change(instance, :result).to(nil) }
    end
  end

  describe "#ranking_change=" do
    subject(:set_rank_change) { instance.rank_change = val }

    context "when value is 'img/rank_up.png'" do
      let(:val) { "img/rank_up.png" }

      it { expect { set_rank_change }.to change(instance, :rank_change).to(:rank_up) }
    end

    context "when value is 'img/rank_down.png'" do
      let(:val) { "img/rank_down.png" }

      it { expect { set_rank_change }.to change(instance, :rank_change).to(:rank_down) }
    end

    context "when value is nil" do
      let(:val) { nil }

      before { instance.rank_change = "img/rank_up.png" }

      it { expect { set_rank_change }.to change(instance, :rank_change).to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "img/rank_hogehoge.png" }

      before { instance.rank_change = "img/rank_up.png" }

      it { expect { set_rank_change }.to change(instance, :rank_change).to(nil) }
    end
  end

  describe "#opponent_rank=" do
    subject(:set_opponent_rank) { instance.opponent_rank = val }

    context "when value is '25段'" do
      let(:val) { "25段" }

      it { expect { set_opponent_rank }.to change(instance, :opponent_rank).to(25) }
    end

    context "when value is nil" do
      let(:val) { nil }

      before { instance.opponent_rank = "20段" }

      it { expect { set_opponent_rank }.to change(instance, :opponent_rank).to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "godlike" }

      before { instance.opponent_rank = "20段" }

      it { expect { set_opponent_rank }.to change(instance, :opponent_rank).to(nil) }
    end
  end

  describe "#player_char=" do
    subject(:set_player_char) { instance.player_char = val }

    context "when value is '梅喧'" do
      let(:val) { "梅喧" }

      it { expect { set_player_char }.to change(instance, :player_char).to(:BA) }
    end

    context "when value is nil" do
      let(:val) { nil }

      before { instance.player_char = "ソル" }

      it { expect { set_player_char }.to change(instance, :player_char).to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "テスタメント" }

      before { instance.player_char = "ソル" }

      it { expect { set_player_char }.to change(instance, :player_char).to(nil) }
    end
  end

  describe "#opponent_char=" do
    subject(:set_opponent_char) { instance.opponent_char = val }

    context "when value is 'カイ'" do
      let(:val) { "カイ" }

      it { expect { set_opponent_char }.to change(instance, :opponent_char).to(:KY) }
    end

    context "when value is nil" do
      let(:val) { nil }

      before { instance.opponent_char = "カイ" }

      it { expect { set_opponent_char }.to change(instance, :opponent_char).to(nil) }
    end

    context "when value is unexpected" do
      let(:val) { "ザッパ" }

      before { instance.opponent_char = "カイ" }

      it { expect { set_opponent_char }.to change(instance, :opponent_char).to(nil) }
    end
  end
end
