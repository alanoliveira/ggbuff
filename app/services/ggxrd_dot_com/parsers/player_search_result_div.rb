# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class PlayerSearchResultDiv
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def url
        anchor.attribute("href")&.value
      end

      def name
        anchor.text
      end

      private

      def anchor
        @anchor ||= node.xpath("div[@class='searchResultList']/a").first || (raise UnexpectedStructureError)
      end
    end
  end
end
