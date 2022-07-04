# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchVictims do
  let(:instance) { described_class.new(player.matches) }
  let(:player) { create(:player) }
  let(:opponent1) { create(:player) }
  let(:opponent2) { create(:player) }
  let(:opponent3) { create(:player) }

  before do
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent1, opponent_char: :PO)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent2, opponent_char: :LE)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent2, opponent_char: :LE)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent2, opponent_char: :LE)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent2, opponent_char: :LE)
    create(:match, player: player, player_char: :BA, result: :lose, opponent: opponent3, opponent_char: :MI)
    create(:match, player: player, player_char: :BA, result: :win, opponent: opponent3, opponent_char: :MI)
  end

  describe "#search" do
    subject { instance.search }

    it do
      is_expected.to match_array(
        [
          an_object_having_attributes(player_id: player.id, opponent_char: :LE, opponent_id: opponent2.id, total: 4,
                                      wins: 4),
          an_object_having_attributes(player_id: player.id, opponent_char: :PO, opponent_id: opponent1.id, total: 10,
                                      wins: 5),
          an_object_having_attributes(player_id: player.id, opponent_char: :MI, opponent_id: opponent3.id, total: 2,
                                      wins: 1)
        ]
      )
    end

    context "when a limit is used" do
      subject { instance.search(limit: 2) }

      it do
        is_expected.to match_array(
          [
            an_object_having_attributes(player_id: player.id, opponent_char: :LE, opponent_id: opponent2.id, total: 4,
                                        wins: 4),
            an_object_having_attributes(player_id: player.id, opponent_char: :PO, opponent_id: opponent1.id, total: 10,
                                        wins: 5)
          ]
        )
      end
    end
  end
end
