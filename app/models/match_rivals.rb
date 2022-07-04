# frozen_string_literal: true

class MatchRivals
  def initialize(match_relation)
    @match_relation = match_relation
  end

  def search(limit: nil)
    rel = match_relation
    rel = rel.where.not(opponent: nil)
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
        opponent_id:   item[1],
        opponent_char: item[2].to_sym,
        total:         item[3],
        wins:          item[4]
      }
    )
  end

  def grouping(rel)
    rel.group(:player_id, :opponent_id, :opponent_char)
  end

  def ordering(rel)
    rel.reorder("COUNT(1) DESC")
  end

  def plucking(rel)
    rel.pluck(:player_id, :opponent_id, :opponent_char, "COUNT(1)", "SUM(result)")
  end
end
