# frozen_string_literal: true

module GgxrdDotCom
  class Client
    class ClientError < StandardError; end
    class InMaintenanceError < ClientError; end
    class NotAuthenticatedError < ClientError; end

    include HTTParty
    base_uri "http://www.ggxrd.com/pg2"
    follow_redirects false
    logger           Rails.logger, :debug

    def initialize(cookies=nil)
      @cookie_hash = HTTParty::CookieHash.new
      cookie_hash.add_cookies(cookies) if cookies
      index if cookie_hash.empty? # used to initialize the cookies
    end

    def index
      Rails.logger.debug("[GGXRD-CLI] [index]")

      request(:get, "/index.php")
    end

    def login(login, password, autologin)
      Rails.logger.debug { "[GGXRD-CLI] [login] user = #{login}" }

      request(:post,
              "/login.php",
              query: {c: Time.now.to_i},
              body:  {login_id:  login,
                      password:  password,
                      autologin: autologin,
                      btn_login: "ログイン"})
    end

    def select_aime(aime_key)
      Rails.logger.debug { "[GGXRD-CLI] [select_aime] aime_key = #{aime_key}" }
      aime_key = aime_key.to_i

      request(:get, "/login.php", query: {mode: "select", aime_key: aime_key})
    end

    def profile
      Rails.logger.debug("[GGXRD-CLI] [profile]")

      request(:get, "/profile_view.php")
    end

    def player_search(player_name, page=1)
      Rails.logger.debug { "[GGXRD-CLI] [player_search] {player_name: #{player_name}} {page: #{page}}" }
      page = page.to_i
      raise ArgumentError "negative page number" unless page.positive?

      request(:get, "/player_search.php",
              query: {p:           page,
                      mode:        "search",
                      player_name: player_name})
    end

    def play_log(page=1)
      Rails.logger.debug { "[GGXRD-CLI] [play_log] {page: #{page}}" }
      page = page.to_i
      raise ArgumentError "negative page number" unless page.positive?

      request(:get, "/play_log_view.php", query: {p: page})
    end

    def member_profile_view(ggxrd_user_id)
      Rails.logger.debug { "[GGXRD-CLI] [member_profile_view] {ggxrd_user_id: #{ggxrd_user_id}}" }

      request(:get, "/member_profile_view.php", query: {user_id: ggxrd_user_id})
    end

    def cookies
      cookie_hash.to_cookie_string
    end

    private

    attr_reader :cookie_hash

    def request(method, path, opts={})
      opts[:headers] = {"cookie" => cookies}
      response = self.class.send(method, path, opts)
      ResponseValidator.new(response).validate!
      resp_cookies = response.get_fields("Set-Cookie") || []
      resp_cookies.each {|c| cookie_hash.add_cookies(c) }

      ResponseValidator.new(response).validate!
      response.response
    end
  end
end
