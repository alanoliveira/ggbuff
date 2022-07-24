# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class ProfilePage < BasePageParser
      def player_name
        node = doc.xpath('//dd[@class="field show player_name"]').first
        raise UnexpectedStructureError.new if node.nil?

        sanitize node.text
      end

      private

      def sanitize(str)
        str.delete_suffix(" [変更]")
      end
    end
  end
end
