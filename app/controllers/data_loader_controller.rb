# frozen_string_literal: true

class DataLoaderController < ApplicationController
  include UsesGgxrdApi

  def load_matches
    last_matches_load_process = current_player.matches_load_processes.last
    if last_matches_load_process.nil? || last_matches_load_process.ended?
      ggxrd_api.profile # validate ggxrd.com auth cookies
      matches_load_process = current_player.matches_load_processes.create
      enqueue_matches_load_process(matches_load_process)
      load_matches_limit_flash
    end

    redirect_to request.referer || root_url
  end

  def load_player
    PlayerLoader.new(ggxrd_api).load_player(current_player_ggxrd_user_id)

    redirect_to root_url
  end

  private

  def load_matches_limit_flash
    return if Rails.configuration.ggbuff.matches_loader[:skip_older_than].blank?

    flash[:info] =
      t("texts.loading_matches_limit", num_days: Rails.configuration.ggbuff.matches_loader[:skip_older_than] / 1.day)
  end

  def enqueue_matches_load_process(matches_load_process)
    options = {}
    options[:wait] = 1.minute if matches_load_process.updated_at < 1.minute # to avoid spamming clicks
    MatchesLoaderJob.set(options).perform_later(matches_load_process.id, ggxrd_api.cookies)
  end
end
