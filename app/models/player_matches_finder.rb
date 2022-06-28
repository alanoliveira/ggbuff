# frozen_string_literal: true

class PlayerMatchesFinder
  include ActiveModel::Model

  attr_accessor :player_char,
                :player_rank_min,
                :player_rank_max,
                :opponent_name,
                :opponent_name_partial,
                :opponent_char,
                :opponent_rank_min,
                :opponent_rank_max,
                :played_at_from,
                :played_at_to

  def initialize(player, attrs={})
    @player = player
    assign_attributes(attrs)
  end

  def execute
    search = player.matches.eager_load(:store, :opponent)
    search = add_search_params_for_player(search)
    search = add_search_params_for_opponent(search)
    if played_at_from.present? || played_at_to.present?
      search = search.where(played_at: Range.new(played_at_from, played_at_to))
    end
    search
  end

  private

  attr_reader :player

  def add_search_params_for_player(search)
    if player_rank_min.present? || player_rank_max.present?
      search = search.where(player_rank: Range.new(player_rank_min, player_rank_max))
    end

    search = search.where(player_char: player_char) if player_char.present?
    search
  end

  def add_search_params_for_opponent(search)
    search = opponent_name_search(search)
    if opponent_rank_min.present? || opponent_rank_max.present?
      search = search.where(opponent_rank: Range.new(opponent_rank_min, opponent_rank_max))
    end

    search = search.where(opponent_char: opponent_char) if opponent_char.present?
    search
  end

  def opponent_name_search(search)
    return search if opponent_name.blank?

    if opponent_name_partial
      search.joins(:opponent).where("lower(player_name) like '%#{opponent_name.downcase}%'")
    else
      search.joins(:opponent).where("lower(player_name) = '#{opponent_name.downcase}'")
    end
  end
end
