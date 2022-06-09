# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::PlayLogDiv do
  let(:instance) { described_class.new(node) }
  let(:node) { Nokogiri::HTML::DocumentFragment.parse(html).elements.first }
  let(:opponent_name) { "Rival" }
  let(:opponent_profile_url) { "http://..." }
  let(:player_char) { "カイ" }
  let(:opponent_char) { "ポチョムキン" }
  let(:player_rank) { "17段" }
  let(:opponent_rank) { "18段" }
  let(:shop_name) { "My Game Center" }
  let(:play_date) { "08/09 23:17" }
  let(:rank_up) { true }
  let(:rank_down) { false }
  let(:result) { "win" }
  let(:html) do
    <<-HTML
        <div class="playLog">
          <h3><span class="#{result&.downcase}">#{result&.upcase}</span> vs #{opponent_char} </h3>
          <div class="iconBox cf">
            #{"<div id='icon_status'><img src='img/rank_up.png' width='50'></div>" if rank_up}
            #{"<div id='icon_status'><img src='img/rank_down.png' width='50'></div>" if rank_down}
            <div><img src="img/thumb_xxx.jpg" width="60"><br>#{player_rank}</div>
            <div id="vs">VS</div>
            <div><img src="img/thumb_xxx.jpg" width="60"><br>#{opponent_rank}</div>
          </div>
          <p class="my_player"><span>使用キャラクター：</span>#{player_char}</p>
          <p class="enemy_player"><span>相手プレイヤー名：</span><a href="#{opponent_profile_url}">#{opponent_name}</a></p>
          <p class="shop_name"><span>対戦場所：</span>#{shop_name}</p>
          <p class="play_time"><span>対戦時刻：</span>#{play_date}</p>
        </div>
    HTML
  end

  describe "#result" do
    let(:subject) { instance.result }

    context "when it is win" do
      let(:result) { "win" }
      it { is_expected.to eq result }
    end

    context "when it is lose" do
      let(:result) { "lose" }
      it { is_expected.to eq result }
    end

    include_examples "unexpected html structure"
  end

  describe "#icon_status_image" do
    let(:subject) { instance.icon_status_image }

    context "when it is rank_up" do
      let(:rank_up) { true }
      let(:rank_down) { false }
      it { is_expected.to eq "img/rank_up.png" }
    end

    context "when it is rank_down" do
      let(:rank_up) { false }
      let(:rank_down) { true }
      it { is_expected.to eq "img/rank_down.png" }
    end

    context "when rank do not change" do
      let(:rank_up) { false }
      let(:rank_down) { false }
      it { is_expected.to eq nil }
    end
  end

  describe "#player_rank" do
    let(:subject) { instance.player_rank }

    context "when it exists" do
      let(:player_rank) { "賞金首" }
      it { is_expected.to eq player_rank }
    end

    context "when do not exists" do
      let(:player_rank) { "" }
      it { is_expected.to eq player_rank }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_rank" do
    let(:subject) { instance.opponent_rank }

    context "when it exists" do
      let(:opponent_rank) { "25段" }
      it { is_expected.to eq opponent_rank }
    end

    context "when do not exists" do
      let(:opponent_rank) { "" }
      it { is_expected.to eq opponent_rank }
    end

    include_examples "unexpected html structure"
  end

  describe "#player_char" do
    let(:subject) { instance.player_char }

    context "when it exists" do
      let(:player_char) { "梅喧" }
      it { is_expected.to eq player_char }
    end

    context "when do not exists" do
      let(:player_char) { "" }
      it { is_expected.to eq player_char }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_char" do
    let(:subject) { instance.opponent_char }

    context "when it exists" do
      let(:opponent_char) { "メイ" }
      it { is_expected.to eq opponent_char }
    end

    context "when do not exists" do
      let(:opponent_char) { "" }
      it { is_expected.to eq opponent_char }
    end

    include_examples "unexpected html structure"
  end

  describe "#shop_name" do
    let(:subject) { instance.shop_name }

    context "when it exists" do
      let(:shop_name) { "ミカド" }
      it { is_expected.to eq shop_name }
    end

    context "when do not exists" do
      let(:shop_name) { "" }
      it { is_expected.to eq shop_name }
    end

    include_examples "unexpected html structure"
  end

  describe "#play_date" do
    let(:subject) { instance.play_date }

    context "when it exists" do
      let(:play_date) { "12/31 15:00" }
      it { is_expected.to eq play_date }
    end

    context "when do not exists" do
      let(:play_date) { "" }
      it { is_expected.to eq play_date }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_name" do
    let(:subject) { instance.opponent_name }

    context "when it exists" do
      let(:opponent_name) { "ねこねこ" }
      it { is_expected.to eq opponent_name }
    end

    context "when do not exists" do
      let(:opponent_name) { "" }
      it { is_expected.to eq opponent_name }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_profile_url" do
    let(:subject) { instance.opponent_profile_url }

    context "when it exists" do
      let(:opponent_profile_url) { "http://ggxrd.com/fugefuge/hogehoge/123" }
      it { is_expected.to eq opponent_profile_url }
    end

    context "when do not exists" do
      let(:opponent_profile_url) { "" }
      it { is_expected.to eq opponent_profile_url }
    end

    include_examples "unexpected html structure"
  end
end
