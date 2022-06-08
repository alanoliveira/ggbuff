# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class PlayDate < BaseModel
      PLAY_TIME_RE = %r{(\d{2})/(\d{2}) (\d{2}):(\d{2})}.freeze
      DUMMY_YEAR = 2000 # make sure it is a leap year
      attr_reader :month, :day, :hour, :minute

      def self.create(str)
        matches = str.match(PLAY_TIME_RE)
        return PlayDate.new if matches.nil?

        PlayDate.new(month: matches[1], day: matches[2], hour: matches[3], minute: matches[4])
      end

      def month=(val)
        @month = val.to_i
      end

      def day=(val)
        @day = val.to_i
      end

      def minute=(val)
        @minute = val.to_i
      end

      def hour=(val)
        @hour = val.to_i
      end

      def to_date_time
        DateTime.new(DUMMY_YEAR, month, day, hour, minute)
      rescue Date::Error, TypeError
        nil
      end

      validates :month, :day, :hour, :minute, presence: true
      validates :to_date_time, is_a: {type: DateTime}
    end
  end
end
