# frozen_string_literal: true

class MatchTormentors < MatchRivals
  private

  def ordering(rel)
    rel.reorder("SUM(result) ASC, played_at DESC")
  end
end
