# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class PlayLog < BaseValue
      property :logs, default: []

      def populate(parser)
        parser.play_logs.map do |m|
          l = Log.new
          l.populate(m)
          logs.push(l)
        end
      end

      class Log < BaseValue
        DUMMY_PLAY_DATE_YEAR = 2000 # make sure it is a leap year

        property :result, transform_with: ->(value) { result_to_sym(value) }
        property :rank_change, transform_with: ->(value) { rank_change_to_sym(value) }
        property :player_rank, transform_with: ->(value) { rank_to_num(value) }
        property :opponent_rank, transform_with: ->(value) { rank_to_num(value) }
        property :player_char, transform_with: ->(value) { char_name_to_sym(value) }
        property :opponent_char, transform_with: ->(value) { char_name_to_sym(value) }
        property :play_date, transform_with: ->(value) { play_date_with_year(value) }
        property :opponent_profile_url, transform_with: ->(value) { ProfileUrl.new(url: value) }
        property :shop_name
        property :opponent_name

        # rubocop:disable Metrics/AbcSize
        def populate(parser)
          self.result = parser.result
          self.rank_change = parser.icon_status_image
          self.player_rank = parser.player_rank
          self.opponent_rank = parser.opponent_rank
          self.player_char = parser.player_char
          self.opponent_char = parser.opponent_char
          self.play_date = parser.play_date
          self.shop_name = parser.shop_name
          self.opponent_name = parser.opponent_name
          self.opponent_profile_url = parser.opponent_profile_url
        end
        # rubocop:enable Metrics/AbcSize

        class << self
          private

          def play_date_with_year(play_date)
            "#{DUMMY_PLAY_DATE_YEAR}/#{play_date}" if play_date.present?
          end

          def result_to_sym(result)
            Enums::PLAY_LOG_RESULTS[result]
          end

          def rank_change_to_sym(direction)
            Enums::PLAY_LOG_RANK_DIRECTIONS[direction]
          end

          def rank_to_num(rank)
            Enums::RANKS[rank]
          end

          def char_name_to_sym(char_name)
            Enums::CHAR_NAMES[char_name]
          end
        end
      end
    end
  end
end
