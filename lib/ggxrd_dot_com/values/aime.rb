# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class Aime < BaseValue
      property :aime_name
      property :url

      def populate(parser)
        self.aime_name = parser.name
        self.url = parser.url
      end

      def id
        url[/\d+$/]
      end
    end
  end
end
