# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class PlayerSearchPage < BasePageParser
      def result_list
        doc.xpath('//div[@class="searchResultList"]').map do |d|
          PlayerSearchResultDiv.new(d)
        end
      end
    end
  end
end
