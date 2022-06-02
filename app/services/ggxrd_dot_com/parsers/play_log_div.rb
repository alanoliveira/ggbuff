# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class PlayLogDiv
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def result
        n = node.xpath("div/h3/span[@class='win' or @class='lose']")
        raise UnexpectedStructureError if n.length != 1

        n.attribute("class")&.value
      end

      def icon_status_image
        n = node.xpath("div/div[@class='iconBox cf']/div[@id='icon_status']/img")
        raise UnexpectedStructureError if n.length > 1

        n.attribute("src")&.value
      end

      def player_rank
        n = node.xpath("div/div[@class='iconBox cf']/div[not(@id)][1]")
        raise UnexpectedStructureError if n.length != 1

        n.text
      end

      def opponent_rank
        n = node.xpath("div/div[@class='iconBox cf']/div[not(@id)][2]")
        raise UnexpectedStructureError if n.length != 1

        n.text
      end

      def player_char
        n = node.xpath("div/p[@class='my_player']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def opponent_char
        n = node.xpath("div/h3[span[@class='win'or @class='lose']]")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text.delete_prefix!(" vs ").chop!
      end

      def shop_name
        n = node.xpath("div/p[@class='shop_name']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def play_date
        n = node.xpath("div/p[@class='play_time']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def opponent_name
        n = node.xpath("div/p[@class='enemy_player']/a")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def opponent_profile_url
        n = node.xpath("div/p[@class='enemy_player']/a")
        raise UnexpectedStructureError if n.length != 1

        n.attribute("href")&.text
      end
    end
  end
end
