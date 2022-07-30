# frozen_string_literal: true

class DatabaseCleaner
  def initialize
    @conf = Rails.configuration.ggbuff.database_cleaner
  end

  def run
    Rails.logger.info "[DATABASE_CLEANER] started (#{conf})"

    if old_data_threashold.present?
      clean_matches!
      clean_matches_load_processes!
      clean_players!
    end
    Rails.logger.info "[DATABASE_CLEANER] ended"
  end

  private

  attr_reader :conf

  def old_data_threashold
    conf[:old_data_threshold].seconds.ago if conf[:old_data_threshold].present?
  end

  def clean_matches!
    Rails.logger.info "[DATABASE_CLEANER] clean_matches started"
    Match.where(played_at: ..old_data_threashold).find_each do |match|
      Rails.logger.info "[DATABASE_CLEANER] deleting #{match.inspect}"
      match.delete
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_matches ended"
  end

  def clean_matches_load_processes!
    Rails.logger.info "[DATABASE_CLEANER] clean_matches_loader_processes started"
    MatchesLoadProcess.where(created_at: ..old_data_threashold).find_each do |mlp|
      Rails.logger.info "[DATABASE_CLEANER] deleting #{mlp.inspect}"
      mlp.delete
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_matches_loader_processes ended"
  end

  def clean_players!
    Rails.logger.info "[DATABASE_CLEANER] clean_players started"
    Player.inactive.or(Player.where(last_login_at: ..old_data_threashold)).lock.find_each do |player|
      next unless delete_player?(player)

      Rails.logger.info "[DATABASE_CLEANER] deleting #{player.inspect}"
      player.delete
    end
    Rails.logger.info "[DATABASE_CLEANER] clean_players ended"
  end

  def delete_player?(player)
    Match.with_player(player).count.zero?
  end
end
