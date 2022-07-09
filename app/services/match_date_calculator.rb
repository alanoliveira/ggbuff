# frozen_string_literal: true

class MatchDateCalculator
  class CalculationError < StandardError; end

  def calculate(match_date)
    base_date = last_processed_match_date || Time.zone.now

    match_date = match_date.change(year: base_date.year)
    match_date -= 1.year if match_date >= base_date

    self.last_processed_match_date = match_date
  end

  private

  attr_accessor :last_processed_match_date
end
