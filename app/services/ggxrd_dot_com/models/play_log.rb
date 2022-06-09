# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class PlayLog < BaseModel
      attr_accessor :logs

      def self.create(parser)
        new(results: parser.play_logs.map {|m| Log.create(m) })
      end

      validates :logs, is_a: {type: Array}, nested: true

      class Log < BaseModel
        attr_accessor :shop_name, :opponent_name
        attr_reader :result, :rank_change, :player_rank, :opponent_rank, :player_char, :opponent_char, :play_date,
                    :opponent_profile_url

        RESULTS = {"win" => :win, "lose" => :lose}.freeze
        RANK_DIRECTIONS = {"img/rank_up.png" => :rank_up, "img/rank_down.png" => :rank_down}.freeze

        def self.create(parser)
          new(
            result:               parser.result,
            rank_change:          parser.icon_status_image,
            player_rank:          parser.player_rank,
            opponent_rank:        parser.opponent_rank,
            player_char:          parser.player_char,
            opponent_char:        parser.opponent_char,
            play_date:            parser.play_date,
            shop_name:            parser.shop_name,
            opponent_name:        parser.opponent_name,
            opponent_profile_url: parser.opponent_profile_url
          )
        end

        def result=(str)
          @result = RESULTS[str]
        end

        def rank_change=(str)
          @rank_change = RANK_DIRECTIONS[str]
        end

        def player_rank=(str)
          @player_rank = Enums::RANKS[str]
        end

        def opponent_rank=(str)
          @opponent_rank = Enums::RANKS[str]
        end

        def player_char=(str)
          @player_char = Enums::CHAR_NAMES[str]
        end

        def opponent_char=(str)
          @opponent_char = Enums::CHAR_NAMES[str]
        end

        def play_date=(str)
          @play_date = PlayDate.create(str)
        end

        def opponent_profile_url=(str)
          @opponent_profile_url = ProfileUrl.new(url: str)
        end

        validates :result, presence: true, inclusion: {in: %i[win lose]}
        validates :rank_change, inclusion: {in: %i[rank_up rank_down]}
        validates :player_rank, presence: true
        validates :player_rank, :opponent_rank,
                  numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30}
        validates :player_char, :opponent_char, presence: true, inclusion: {in: Enums::CHAR_NAMES.values}
        validates :shop_name, presence: true
        validates :play_date, is_a: {type: PlayDate}, nested: true
      end
    end
  end
end
