# frozen_string_literal: true

class MatchesLoaderJob < ApplicationJob
  queue_as :default

  def perform(matches_load_process_id, auth_cookies)
    matches_load_process = MatchesLoadProcess.find(matches_load_process_id)
    api = GgxrdApi.new(auth_cookies)
    matches_load_process.ggxrd_api = api
    matches_load_process.load!
    matches_load_process.finish!
  rescue StandardError => e
    matches_load_process.update(state: :error, error_description: e.class)
    raise e
  end
end
