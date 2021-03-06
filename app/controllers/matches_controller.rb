# frozen_string_literal: true

class MatchesController < ApplicationController
  include UsesGgxrdApi

  def index
    @player_matches_search_form = PlayerMatchesSearchForm.new(current_player, player_matches_search_form_params)
    @matches = @player_matches_search_form.search
  end

  private

  def player_matches_search_form_params
    params.permit(
      :player_char,
      :player_rank_min,
      :player_rank_max,
      :opponent_name,
      :opponent_name_partial,
      :opponent_char,
      :opponent_rank_min,
      :opponent_rank_max,
      :played_at_from,
      :played_at_to
    )
  end
end
