# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_player, :player_signed_in?
  before_action :require_player

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
end
