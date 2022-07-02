# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_player, :player_signed_in?
  before_action :require_player

  rescue_from GgxrdDotCom::Client::InMaintenanceError do |e|
    flash_error(e)
    redirect_to request.referer || root_url
  end

  rescue_from GgxrdDotCom::Client::NotAuthenticatedError do |e|
    flash_error(e)
    session.clear

    redirect_to login_url
  end

  def render(*args)
    flash_matches_loader_status
    super
  end

  def current_player
    return unless session[:player_id]

    @current_player ||= Player.find(session[:player_id])
  end

  def player_signed_in?
    current_player.present?
  end

  def require_player
    redirect_to(login_url) unless player_signed_in?
  end

  def flash_matches_loader_status
    return unless player_signed_in?

    matches_load_process = current_player.matches_load_processes.last
    return if matches_load_process.nil?

    flash.now[:warning] = t("texts.loading_matches") unless matches_load_process.ended?
    flash.now[:danger] = t("texts.loading_matches_error") if matches_load_process.error?
  end

  private

  def flash_error(err, flash_type: :warning)
    flash[flash_type] = t "errors.#{err.class.to_s.gsub('::', '.').underscore}"
  end
end
