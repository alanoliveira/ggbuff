# frozen_string_literal: true

class PlayerLoader
  class Error < StandardError; end
  class UserIdNotFoundError < Error; end
  MAX_SEARCH_PLAYER_PAGE = 2

  def initialize(ggxrd_api)
    @api = ggxrd_api
  end

  def load_player
    ggxrd_user_id = fetch_ggxrd_user_id
    player = Player.lock.find_or_initialize_by(ggxrd_user_id: ggxrd_user_id)
    player.update(player_name: profile.player_name)
    player
  end

  private

  attr_reader :api

  def profile
    @profile ||= api.profile
  end

  def fetch_ggxrd_user_id
    # prevent long searches when the username is too commom ('GG PLAYER' for example)
    (1..MAX_SEARCH_PLAYER_PAGE).each do |page|
      search_result = api.search_player(profile.player_name, page)
      search_result.results.each do |r|
        result_id = r.profile_url.id
        return result_id if api.my_id?(result_id)
      end
    end

    raise UserIdNotFoundError
  end
end
