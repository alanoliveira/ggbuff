# frozen_string_literal: true

class MatchesLoader
  def initialize(ggxrd_dot_com_api, player)
    @api = ggxrd_dot_com_api
    @player = player
  end

  def load_matches
    Match.transaction do
      api_matches.each do |m|
        match = find_or_initialize_match(m)
        break unless match.new_record?

        # As we don't have the ggxrd.com id for store, is better not use it to find_or_initialize
        match.store = load_store(m)
        match.save
      end
    end
  end

  private

  attr_reader :api, :player

  def api_matches
    Enumerator.new do |enum|
      (1..).each do |page|
        matches = api.matches(page)
        break if matches.logs.empty?

        matches.logs.each do |l|
          enum.yield l
        end
      end
    end
  end

  def find_or_initialize_match(match)
    Match.lock.find_or_initialize_by(
      opponent_char: match.opponent_char,
      opponent_rank: match.opponent_rank,
      player_char:   match.player_char,
      player_rank:   match.player_rank,
      rank_change:   match.rank_change,
      result:        match.result,
      played_at:     match.play_date.to_date_time,
      opponent:      load_opponent(match),
      player:        player
    )
  end

  def load_opponent(match)
    return if match.opponent_profile_url.nil?

    opponent = Player.lock.find_or_initialize_by(ggxrd_user_id: match.opponent_profile_url.id)
    opponent.update(player_name: match.opponent_name)
    opponent
  end

  def load_store(match)
    Store.lock.find_or_create_by(name: match.shop_name)
  end
end
