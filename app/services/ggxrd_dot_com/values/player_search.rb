# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class PlayerSearch < BaseValue
      property :results, default: []

      def populate(parser)
        parser.result_list.each do |m|
          r = Result.new
          r.populate(m)
          results.push(r)
        end
      end

      class Result < BaseValue
        property :player_name
        property :profile_url, transform_with: ->(value) { ProfileUrl.new(url: value) }

        def populate(parser)
          self.player_name = parser.player_name
          self.profile_url = parser.url
        end
      end
    end
  end
end
