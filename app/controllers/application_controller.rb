# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_player, :player_signed_in?
  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || locale_from_accept_language || I18n.default_locale
  end

  def locale_from_accept_language
    accept_lang = request.get_header("HTTP_ACCEPT_LANGUAGE")
    return if accept_lang.nil?

    accept_lang
      .split(",")
      .map {|l| l[0..1].to_sym }
      .uniq
      .find {|l| I18n.available_locales.include?(l) }
  end

  def current_player
    return unless session[:player_id]

    @current_player ||= Player.find(session[:player_id])
  end

  def player_signed_in?
    current_player.present?
  end
end
