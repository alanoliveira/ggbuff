# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_player, :player_signed_in?
  before_action :require_player
  around_action :flash_matches_loader_status

  rescue_from GgxrdDotCom::Client::InMaintenanceError do |e|
    flash_error(e)
    redirect_to request.referer || root_url
  end

  rescue_from GgxrdDotCom::Client::NotAuthenticatedError do |e|
    flash_error(e)
    session.clear

    redirect_to login_url
  end

  def player_signed_in?
    current_player_ggxrd_user_id.present?
  end

  def current_player
    return unless player_signed_in?

    @current_player ||= Player.find_or_create_by(ggxrd_user_id: current_player_ggxrd_user_id)
  end

  def require_player
    redirect_to(login_url) if current_player.blank?
  end

  def flash_matches_loader_status
    if player_signed_in?
      matches_load_process = current_player.matches_load_processes.last

      flash.now[:warning] = t("texts.loading_matches") if matches_load_process&.running?
      flash.now[:danger] = t("texts.loading_matches_error") if matches_load_process&.error?
    end

    yield
  end

  private

  def current_player_ggxrd_user_id
    session[:ggxrd_user_id]
  end

  def flash_error(err, flash_type: :warning)
    flash[flash_type] = t "errors.#{err.class.to_s.gsub('::', '.').underscore}"
  end
end
