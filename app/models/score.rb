# frozen_string_literal: true

class Score < Hashie::Dash
  property :player_id
  property :player_char
  property :opponent_id
  property :opponent_char
  property :total
  property :wins

  def loses
    total - wins
  end

  def player
    @player = Player.find_by(id: player_id)
  end

  def opponent
    @opponent = Player.find_by(id: opponent_id)
  end
end
