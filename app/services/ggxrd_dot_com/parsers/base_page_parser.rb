# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class BasePageParser
      def initialize(html)
        @doc = Nokogiri::HTML(html)
      end

      attr_reader :doc
    end
  end
end
