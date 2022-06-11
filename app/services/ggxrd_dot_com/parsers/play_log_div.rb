# frozen_string_literal: true

module GgxrdDotCom
  module Parsers
    class PlayLogDiv
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def result
        n = node.xpath("h3/span[@class='win' or @class='lose']")
        raise UnexpectedStructureError if n.length != 1

        n.attribute("class")&.value
      end

      def icon_status_image
        n = node.xpath("div[@class='iconBox cf']/div[@id='icon_status']/img")
        raise UnexpectedStructureError if n.length > 1

        n.attribute("src")&.value
      end

      def player_rank
        n = node.xpath("div[@class='iconBox cf']/div[not(@id)][1]")
        raise UnexpectedStructureError if n.length != 1

        n.text
      end

      def opponent_rank
        n = node.xpath("div[@class='iconBox cf']/div[not(@id)][2]")
        raise UnexpectedStructureError if n.length != 1

        n.text
      end

      def player_char
        n = node.xpath("p[@class='my_player']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def opponent_char
        n = node.xpath("h3[span[@class='win'or @class='lose']]")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text.delete_prefix!(" vs ").chop!
      end

      def shop_name
        n = node.xpath("p[@class='shop_name']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def play_date
        n = node.xpath("p[@class='play_time']")
        raise UnexpectedStructureError if n.length != 1

        n.xpath("text()").text
      end

      def opponent_name
        n = enemy_player_p.xpath("a[starts-with(@href, 'member_profile_view.php')]")
        n = enemy_player_p if n.empty?

        n.xpath("text()").text
      end

      def opponent_profile_url
        n = enemy_player_p.xpath("a[starts-with(@href, 'member_profile_view.php')]")
        return "" if n.length.zero?

        n.attribute("href").text
      end

      private

      def enemy_player_p
        return @enemy_player_p if @enemy_player_p.present?

        n = node.xpath("p[@class='enemy_player']")
        raise UnexpectedStructureError if n.length != 1

        @enemy_player_p = n
      end
    end
  end
end
