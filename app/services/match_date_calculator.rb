# frozen_string_literal: true

class MatchDateCalculator
  attr_accessor :base_date

  def initialize(base_date=Time.zone.now)
    self.base_date = base_date
  end

  def calculate(match_date)
    match_date = match_date.change(year: base_date.year)
    match_date -= 1.year if match_date >= base_date

    match_date
  end
end
