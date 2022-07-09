# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlayerMatchesSearchForm do
  let(:instance) { described_class.new(player, params) }
  let(:player) { create(:player, player_name: "Baiken Player") }
  let(:params) { {} }

  describe "#search" do
    subject(:search) { instance.search }

    context "when searching without parameters" do
      before do
        create_list(:match, 5, player: player)
        create_list(:match, 5)
      end

      it { expect(search.count).to eq 5 }
      it { expect(search).to all(have_attributes(player: player)) }
    end

    context "when searching by player char" do
      let(:params) { {player_char: :BA} }

      before do
        create_list(:match, 5, player: player, player_char: :BA)
        create_list(:match, 5, player: player, player_char: :KY)
      end

      it { expect(search.count).to eq 5 }
      it { expect(search).to all(be_player_char_BA) }
    end

    context "when searching by player rank min" do
      let(:params) { {player_rank_min: 15} }

      before do
        (10..20).each {|r| create(:match, player: player, player_rank: r) }
      end

      it { expect(search.count).to eq 6 }
      it { expect(search).to all(have_attributes(player_rank: a_value >= 15)) }
    end

    context "when searching by player rank max" do
      let(:params) { {player_rank_max: 18} }

      before do
        (10..20).each {|r| create(:match, player: player, player_rank: r) }
      end

      it { expect(search.count).to eq 9 }
      it { expect(search).to all(have_attributes(player_rank: a_value <= 18)) }
    end

    context "when searching by player rank range" do
      let(:params) { {player_rank_min: 15, player_rank_max: 18} }

      before do
        (10..20).each {|r| create(:match, player: player, player_rank: r) }
      end

      it { expect(search.count).to eq 4 }
      it { expect(search).to all(have_attributes(player_rank: a_value_between(15, 18))) }
    end

    context "when searching by opponent name" do
      let(:params) { {opponent_name: "slayer player"} }

      before do
        create_list(:match, 5, player: player, opponent: create(:player, player_name: "Slayer Player"))
        create_list(:match, 5, player: player, opponent: create(:player, player_name: "Slayer"))
      end

      it { expect(search.count).to eq 5 }
      it { expect(search).to all(have_attributes(opponent_name: "Slayer Player")) }
    end

    context "when searching by opponent name partial" do
      let(:params) { {opponent_name: "slayer", opponent_name_partial: true} }

      before do
        create_list(:match, 5, player: player, opponent: create(:player, player_name: "Slayer Player"))
        create_list(:match, 5, player: player, opponent: create(:player, player_name: "Slayer"))
      end

      it { expect(search.count).to eq 10 }
      it { expect(search).to all(have_attributes(opponent_name: a_string_starting_with("Slayer"))) }
    end

    context "when searching by opponent char" do
      let(:params) { {opponent_char: :MA} }

      before do
        create_list(:match, 5, player: player, opponent_char: :MA)
        create_list(:match, 5, player: player, opponent_char: :KY)
      end

      it { expect(search.count).to eq 5 }
      it { expect(search).to all(be_opponent_char_MA) }
    end

    context "when searching by opponent rank min" do
      let(:params) { {opponent_rank_min: 15} }

      before do
        (10..20).each {|r| create(:match, player: player, opponent_rank: r) }
      end

      it { expect(search.count).to eq 6 }
      it { expect(search).to all(have_attributes(opponent_rank: a_value >= 15)) }
    end

    context "when searching by opponent rank max" do
      let(:params) { {opponent_rank_max: 18} }

      before do
        (10..20).each {|r| create(:match, player: player, opponent_rank: r) }
      end

      it { expect(search.count).to eq 9 }
      it { expect(search).to all(have_attributes(opponent_rank: a_value <= 18)) }
    end

    context "when searching by opponent rank" do
      let(:params) { {opponent_rank_min: 20, opponent_rank_max: 25} }

      before do
        (20..30).each {|r| create(:match, player: player, opponent_rank: r) }
      end

      it { expect(search.count).to eq 6 }
      it { expect(search).to all(have_attributes(opponent_rank: a_value_between(20, 25))) }
    end

    context "when searching by play date from" do
      let(:params) { {played_at_from: "2022-02-01"} }

      before do
        10.times {|x| create(:match, player: player, played_at: "2022-01-01".to_date + (x * 10).days) }
      end

      it { expect(search.count).to eq 6 }
      it { expect(search).to all(have_attributes(played_at: a_value >= "2022-02-01".to_date)) }
    end

    context "when searching by play date to" do
      let(:params) { {played_at_to: "2022-02-01"} }

      before do
        10.times {|x| create(:match, player: player, played_at: "2022-01-01".to_date + (x * 10).days) }
      end

      it { expect(search.count).to eq 4 }
      it { expect(search).to all(have_attributes(played_at: a_value <= "2022-02-01".to_date)) }
    end

    context "when searching by play date range" do
      let(:params) { {played_at_from: "2022-02-01", played_at_to: "2022-03-01"} }

      before do
        10.times {|x| create(:match, player: player, played_at: "2022-01-01".to_date + (x * 10).days) }
      end

      it { expect(search.count).to eq 2 }

      it do
        expect(search).to all(have_attributes(played_at: a_value_between("2022-02-01".to_date, "2022-03-01".to_date)))
      end
    end
  end
end
