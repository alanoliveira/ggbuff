# frozen_string_literal: true

class DatabaseCleaner
  def initialize
    @conf = Rails.configuration.ggbuff.database_cleaner
  end

  def run
    Rails.logger.info "[DATABASE_CLEANER] started (#{conf})"
    clean_matches
    clean_matches_load_processes
    clean_players
    Rails.logger.info "[DATABASE_CLEANER] ended"
  end

  private

  attr_reader :conf

  def clean_matches
    return if old_matches_threashold.blank?

    Rails.logger.info "[DATABASE_CLEANER] clean_old_matches started"
    Match.where("played_at <= ?", old_matches_threashold).find_each do |match|
      Rails.logger.info "[DATABASE_CLEANER] deleting #{match.inspect}"
      match.delete
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_old_matches ended"
  end

  def old_matches_threashold
    conf[:clean_matches_older_than].seconds.ago if conf[:clean_matches_older_than].present?
  end

  def clean_matches_load_processes
    return if conf[:clean_empty_matches_load_processes].blank?

    Rails.logger.info "[DATABASE_CLEANER] clean_empty_matches_loader_processes started"
    MatchesLoadProcess.finished.each do |mlp|
      if mlp.matches.count.zero?
        Rails.logger.info "[DATABASE_CLEANER] deleting #{mlp.inspect}"
        mlp.delete
      end
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_empty_matches_loader_processes ended"
  end

  def clean_players
    return if conf[:clean_players_without_matches].blank?

    Rails.logger.info "[DATABASE_CLEANER] clean_players_without_matches started"
    Player.lock.all.each do |player|
      if delete_player?(player)
        Rails.logger.info "[DATABASE_CLEANER] deleting #{player.inspect}"
        player.delete
      end
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_players_without_matches ended"
  end

  def delete_player?(player)
    player.matches_load_processes.count.zero? &&
      Match.where(player_id: player.id).or(Match.where(opponent_id: player.id)).count.zero?
  end
end
