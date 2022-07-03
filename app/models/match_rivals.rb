# frozen_string_literal: true

class MatchRivals
  def initialize(match_relation)
    @match_relation = match_relation
  end

  def search(limit: nil)
    rel = match_relation
    rel = grouping(rel)
    rel = ordering(rel)
    rel = rel.limit(limit) if limit.present?
    rel = plucking(rel)
    to_scores(rel)
  end

  private

  attr_reader :match_relation

  def to_scores(rel)
    rel.map do |item|
      to_score(item)
    end
  end

  def to_score(item)
    Score.new(
      {
        player_id:     item[0],
        player_char:   item[1].to_sym,
        opponent_id:   item[2],
        opponent_char: item[3].to_sym,
        total:         item[4],
        wins:          item[5]
      }
    )
  end

  def grouping(rel)
    rel.group(:player_id, :player_char, :opponent_id, :opponent_char)
  end

  def ordering(rel)
    rel.reorder("COUNT(1) DESC, played_at DESC")
  end

  def plucking(rel)
    rel.pluck(:player_id, :player_char, :opponent_id, :opponent_char, "COUNT(1)", "SUM(result)")
  end
end
