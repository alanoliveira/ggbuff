# frozen_string_literal: true

require "rails_helper"

PlayLogDivHtml = Struct.new(:result, :player_char, :opponent_char, :player_rank, :opponent_rank, :opponent_name,
                            :opponent_profile_url, :opponent_guild, :rank_up, :rank_down, :shop_name,
                            :play_date, keyword_init: true) do
  def html_erb
    <<-HTML
    <div class="playLog">
      <h3><span class="<%= result&.downcase %>"><%= result&.upcase %></span> vs <%= opponent_char %> </h3>
      <div class="iconBox cf">
        <% if rank_up %>
          <div id='icon_status'><img src='img/rank_up.png' width='50'></div>
        <% end %>
        <% if rank_down %>
          <div id='icon_status'><img src='img/rank_down.png' width='50'></div>
        <% end %>
        <div><img src="img/thumb_xxx.jpg" width="60"><br><%= player_rank %></div>
        <div id="vs">VS</div>
        <div><img src="img/thumb_xxx.jpg" width="60"><br><%= opponent_rank %></div>
      </div>
      <p class="my_player"><span>使用キャラクター：</span><%= player_char %></p>
      <p class="enemy_player">
        <span>相手プレイヤー名：</span>
        <% if opponent_name.present? %>
          <a href='<%= opponent_profile_url %>'><%= opponent_name %></a>
          <% if opponent_guild.present? %>
            (<a href='guild_view.php?guild_id=1'>opponent_guild</a>)
          <% end %>
        <% elsif opponent_name.nil? %>
          GG PLAYER
        <% end %>
      </p>
      <p class="shop_name"><span>対戦場所：</span><%= shop_name %></p>
      <p class="play_time"><span>対戦時刻：</span><%= play_date %></p>
    </div>
    HTML
  end

  def to_s
    ERB.new(html_erb).result(binding)
  end
end

RSpec.describe GgxrdDotCom::Parsers::PlayLogDiv do
  let(:instance) { described_class.new(node) }
  let(:node) { Nokogiri::HTML::DocumentFragment.parse(html).elements.first }

  describe "#result" do
    subject { instance.result }

    let(:html) { PlayLogDivHtml.new(result: result).to_s }

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
    subject { instance.icon_status_image }

    let(:html) { PlayLogDivHtml.new(rank_up: rank_up, rank_down: rank_down).to_s }

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

      it { is_expected.to be_nil }
    end
  end

  describe "#player_rank" do
    subject { instance.player_rank }

    let(:html) { PlayLogDivHtml.new(player_rank: player_rank).to_s }
    let(:player_rank) { "賞金首" }

    it { is_expected.to eq player_rank }

    context "when it is blank" do
      let(:player_rank) { "" }

      it { is_expected.to eq player_rank }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_rank" do
    subject { instance.opponent_rank }

    let(:html) { PlayLogDivHtml.new(opponent_rank: opponent_rank).to_s }
    let(:opponent_rank) { "19段" }

    it { is_expected.to eq opponent_rank }

    context "when it is blank" do
      let(:opponent_rank) { "" }

      it { is_expected.to eq opponent_rank }
    end

    include_examples "unexpected html structure"
  end

  describe "#player_char" do
    subject { instance.player_char }

    let(:html) { PlayLogDivHtml.new(player_char: player_char).to_s }
    let(:player_char) { "梅喧" }

    it { is_expected.to eq player_char }

    context "when it is blank" do
      let(:player_char) { "" }

      it { is_expected.to eq player_char }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_char" do
    subject { instance.opponent_char }

    let(:html) { PlayLogDivHtml.new(result: "win", opponent_char: opponent_char).to_s }
    let(:opponent_char) { "メイ" }

    it { is_expected.to eq opponent_char }

    context "when it is blank" do
      let(:opponent_char) { "" }

      it { is_expected.to eq opponent_char }
    end

    include_examples "unexpected html structure"
  end

  describe "#shop_name" do
    subject { instance.shop_name }

    let(:html) { PlayLogDivHtml.new(shop_name: shop_name).to_s }
    let(:shop_name) { "WakuWaku Game Center" }

    it { is_expected.to eq shop_name }

    context "when it is blank" do
      let(:shop_name) { "" }

      it { is_expected.to eq shop_name }
    end

    include_examples "unexpected html structure"
  end

  describe "#play_date" do
    subject { instance.play_date }

    let(:html) { PlayLogDivHtml.new(play_date: play_date).to_s }
    let(:play_date) { "12/31 21:50" }

    it { is_expected.to eq play_date }

    context "when it is blank" do
      let(:play_date) { "" }

      it { is_expected.to eq play_date }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_name" do
    subject { instance.opponent_name }

    let(:html) do
      PlayLogDivHtml.new(opponent_name: opponent_name, opponent_guild: opponent_guild,
                         opponent_profile_url: "member_profile_view.php?user_id=1").to_s
    end
    let(:opponent_name) { "Rival" }
    let(:opponent_guild) { nil }

    it { is_expected.to eq opponent_name }

    context "when opponent has a guild" do
      let(:opponent_guild) { "Lamen Lovers" }

      it { is_expected.to eq opponent_name }
    end

    context "when it is blank" do
      let(:opponent_name) { "" }

      it { is_expected.to eq opponent_name }
    end

    context "when opponent not signed" do
      let(:opponent_name) { nil }

      it { is_expected.to eq "GG PLAYER" }
    end

    include_examples "unexpected html structure"
  end

  describe "#opponent_profile_url" do
    subject { instance.opponent_profile_url }

    let(:html) { PlayLogDivHtml.new(opponent_name: "opponent_name", opponent_profile_url: opponent_profile_url).to_s }
    let(:opponent_profile_url) { "member_profile_view.php?user_id=1" }

    it { is_expected.to eq opponent_profile_url }

    context "when opponent has a guild" do
      let(:html) do
        PlayLogDivHtml.new(
          opponent_name:        "opponent_name",
          opponent_guild:       "Lamen Lovers",
          opponent_profile_url: opponent_profile_url
        ).to_s
      end

      it { is_expected.to eq opponent_profile_url }
    end

    context "when it is blank" do
      let(:opponent_profile_url) { "" }

      it { is_expected.to eq opponent_profile_url }
    end

    context "when opponent not signed" do
      let(:html) do
        PlayLogDivHtml.new.to_s
      end

      it { is_expected.to eq "" }
    end

    include_examples "unexpected html structure"
  end
end
