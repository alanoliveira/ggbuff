# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class PlayerSearch < BaseModel
      attr_accessor :results

      def self.create(parser)
        new(results: parser.result_list.map {|m| Result.create(m) })
      end

      validates :results, is_a: {type: Array}, nested: true

      class Result < BaseModel
        attr_accessor :player_name
        attr_reader :profile_url

        def self.create(parser)
          new(player_name: parser.player_name, profile_url: parser.url)
        end

        def profile_url=(str)
          @profile_url = ProfileUrl.new(url: str)
        end

        validates :player_name, presence: true
        validates :profile_url, presence: true, nested: true
      end
    end
  end
end
