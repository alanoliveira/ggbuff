# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class LoginResult < BaseModel
      attr_accessor :error_description, :aime_list

      def login_errors
        error_description.to_s.split("\n").map(&:strip).select {|s| s.starts_with?("・") }
      end

      def self.create(parser)
        new(
          error_description: parser.error_description,
          aime_list:         parser.aime_list.map {|a| Aime.create(a) }
        )
      end
    end
  end
end
