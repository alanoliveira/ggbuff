# frozen_string_literal: true

class SessionsController < ApplicationController
  include UsesGgxrdApi
  skip_before_action :require_player, only: %i[new create choose_aime]

  def new
    redirect_to root_url if player_signed_in?
    @login = LoginForm.new
  end

  def create
    @login = LoginForm.new(login_params)

    authenticate_ret = @login.authenticate_api(ggxrd_api)
    update_ggxrd_cookies

    return render :new, status: :unauthorized if @login.invalid?

    @aime_list = authenticate_ret.aime_list
    return render :aime_select if @aime_list.any?

    start_session

    redirect_to load_player_url
  end

  def choose_aime
    return redirect_to login_url unless params["aime_key"] && ggxrd_api.select_aime(params["aime_key"])

    update_ggxrd_cookies

    start_session

    redirect_to load_player_url
  end

  def destroy
    session.clear
    redirect_to login_url
  end

  private

  def start_session
    ggxrd_user_id = ggxrd_api.fetch_ggxrd_user_id
    session[:ggxrd_user_id] = ggxrd_user_id
    Player.find_or_create_by(ggxrd_user_id: current_player_ggxrd_user_id).update_last_login_at
  end

  def update_ggxrd_cookies
    session[:ggxrd_cookies] = ggxrd_api.cookies
  end

  def login_params
    params.require(:login_form).permit(:sega_id, :password, :remember_me)
  end
end
