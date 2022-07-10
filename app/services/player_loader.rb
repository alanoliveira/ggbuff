# frozen_string_literal: true

class PlayerLoader
  def initialize(ggxrd_api)
    @api = ggxrd_api
  end

  def load_player(ggxrd_user_id)
    player = Player.lock.find_or_initialize_by(ggxrd_user_id: ggxrd_user_id)
    player.update(player_name: api.profile.player_name)
    player
  end

  private

  attr_reader :api
end
