# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class Profile < BaseValue
      property :player_name

      def populate(parser)
        self.player_name = parser.player_name
      end
    end
  end
end
