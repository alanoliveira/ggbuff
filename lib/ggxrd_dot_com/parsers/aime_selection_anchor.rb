# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class AimeSelectionAnchor
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def url
        node.attribute("href")&.value
      end

      def name
        node.child&.text
      end
    end
  end
end
