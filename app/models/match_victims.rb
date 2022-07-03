# frozen_string_literal: true

class MatchVictims < MatchRivals
  private

  def ordering(rel)
    rel.reorder(Arel.sql("(COUNT(1) - SUM(result)) - SUM(result) ASC, COUNT(1) DESC"))
  end
end
