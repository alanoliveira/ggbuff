# frozen_string_literal: true

class PlayerController < ApplicationController
  include UsesGgxrdApi

  def matches
    @player_matches_search_form = PlayerMatchesSearchForm.new(current_player, player_matches_search_form_params)
    @matches = @player_matches_search_form.search.page(params[:page])
  end

  def load_matches
    last_matches_load_process = current_player.matches_load_processes.last
    if last_matches_load_process.nil? || last_matches_load_process.ended?
      matches_load_process = current_player.matches_load_processes.create
      enqueue_matches_load_process(matches_load_process)
    end

    redirect_to request.referer || root_url
  end

  private

  def enqueue_matches_load_process(matches_load_process)
    options = {}
    options[:wait] = 1.minute if matches_load_process.updated_at < 1.minute # to avoid spamming clicks
    MatchesLoaderJob.set(options).perform_later(matches_load_process.id, ggxrd_api.cookies)
  end

  def player_matches_search_form_params
    params.fetch(:player_matches_search_form, {}).permit(
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
