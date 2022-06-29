# frozen_string_literal: true

class SessionsController < ApplicationController
  include UsesGgxrdApi
  skip_before_action :require_player, only: %i[new create]

  def new
    redirect_to root_url if player_signed_in?
    @login = LoginForm.new
  end

  def create
    @login = LoginForm.new(login_params)

    authenticate_ret = @login.authenticate_api(ggxrd_api)
    update_ggxrd_cookies

    return render :new, status: :unauthorized if @login.invalid?

    raise NotImplementedError if authenticate_ret.aime_list.any?

    load_player
    redirect_to root_url
  end

  def destroy
    session.clear
    redirect_to login_url
  end

  private

  def update_ggxrd_cookies
    session[:ggxrd_cookies] = ggxrd_api.cookies
  end

  def load_player
    session[:player_id] = PlayerLoader.new(ggxrd_api).load_player.id
  end

  def login_params
    params.require(:login_form).permit(:sega_id, :password, :remember_me)
  end
end
