# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class Aime < BaseModel
      attr_accessor :name, :url

      def self.create(parser)
        new(name: parser.player_name, url: parser.url)
      end

      def id
        return if url.blank?

        url.scan(/\d+$/).last&.to_i
      end

      validates :name, :url, presence: true
    end
  end
end
