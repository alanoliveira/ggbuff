# frozen_string_literal: true

class MatchDateCalculator
  class CalculationError < StandardError; end

  def initialize(matches_load_process)
    @matches_load_process = matches_load_process
  end

  def calculate(match_date)
    base_date = last_process_loaded_match&.played_at || Time.zone.now

    match_date = match_date.change(year: base_date.year)
    match_date -= 1.year if match_date >= base_date

    match_date
  end

  private

  attr_reader :matches_load_process

  def last_process_loaded_match
    matches_load_process.matches.last
  end
end
