# frozen_string_literal: true

class GgxrdApi
  class Error < StandardError; end
  class UserIdNotFoundError < Error; end
  MAX_SEARCH_PLAYER_PAGE = 2

  delegate_missing_to :api

  def initialize(cookies=nil)
    cli = GgxrdDotCom::Client.new(cookies)
    @api = GgxrdDotCom::Api.new(cli)
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

  private

  attr_reader :api
end
