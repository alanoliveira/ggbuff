# frozen_string_literal: true

class MatchesLoaderJob < ApplicationJob
  queue_as :default

  def perform(matches_load_process_id, auth_cookies)
    matches_load_process = MatchesLoadProcess.find(matches_load_process_id)
    cli = GgxrdDotCom::Client.new(auth_cookies)
    api = GgxrdDotCom::Api.new(cli)
    matches_load_process.ggxrd_dot_com_api = api
    matches_load_process.load!
    matches_load_process.finish!
  rescue StandardError => e
    matches_load_process.update(state: :error, error_description: e.class)
  end
end
