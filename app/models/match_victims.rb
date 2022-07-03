# frozen_string_literal: true

class MatchVictims < MatchRivals
  private

  def ordering(rel)
    rel.reorder("SUM(result) DESC, played_at DESC")
  end
end
