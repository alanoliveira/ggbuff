# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class PlayLogPage < BasePageParser
      def play_logs
        doc.xpath("//div[@class='playLog']").map do |d|
          PlayLogDiv.new(d)
        end
      end
    end
  end
end
