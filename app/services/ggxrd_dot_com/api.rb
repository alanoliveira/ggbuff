# frozen_string_literal: true

module GgxrdDotCom
  class Api
    class ApiError < StandardError; end

    attr_reader :cli

    delegate :cookies, to: :cli

    def initialize(cli)
      @cli = cli
    end

    def login(login, password, remember_me=1)
      login_resp = cli.login(login, password, remember_me)

      parser = GgxrdDotCom::Parsers::LoginResultPage.new(login_resp.body)

      GgxrdDotCom::Models::LoginResult.create(parser)
    end

    def my_id?(id)
      # when you are logged and try to access you member_profile_view it will redirect you to profile page
      cli.member_profile_view(id).is_a?(Net::HTTPFound)
    end

    def profile
      profile_resp = cli.profile
      raise ApiError unless profile_resp.is_a?(Net::HTTPOK)

      parser = GgxrdDotCom::Parsers::ProfilePage.new(profile_resp.body)
      GgxrdDotCom::Models::Profile.create(parser)
    end

    def matches(page=1)
      play_log_resp = cli.play_log(page)
      raise ApiError unless play_log_resp.is_a?(Net::HTTPOK)

      parser = GgxrdDotCom::Parsers::PlayLogPage.new(play_log_resp.body)
      GgxrdDotCom::Models::PlayLog.create(parser)
    end

    def search_player(player_name, page=1)
      player_search_resp = cli.player_search(player_name, page)
      raise ApiError unless player_search_resp.is_a?(Net::HTTPOK)

      parser = GgxrdDotCom::Parsers::PlayerSearchPage.new(player_search_resp.body)
      GgxrdDotCom::Models::PlayerSearch.create(parser)
    end
  end
end
