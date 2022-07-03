# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class LoginResultPage < BasePageParser
      def error_description
        doc.xpath("//div[@class='caution']").text
      end

      def aime_list
        doc.xpath('//ul/li/a[contains(@href, "aime_key")]').map do |a|
          AimeSelectionAnchor.new(a)
        end
      end
    end
  end
end
