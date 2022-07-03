# frozen_string_literal: true

class MatchTormentors < MatchRivals
  private

  def ordering(rel)
    rel.reorder(Arel.sql("(COUNT(1) - SUM(result) - SUM(result)) DESC, COUNT(1) DESC"))
  end
end
