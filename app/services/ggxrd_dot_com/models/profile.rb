# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class Profile < BaseModel
      attr_accessor :player_name

      def self.create(parser)
        new(player_name: parser.player_name)
      end

      validates :player_name, presence: true
    end
  end
end
