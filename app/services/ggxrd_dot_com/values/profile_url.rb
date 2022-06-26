# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class ProfileUrl < BaseValue
      property :url

      def populate(parser)
        self.url = parser.url
      end

      def id
        url[/\d+$/]
      end
    end
  end
end
