# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class LoginResult < BaseValue
      property :error_description
      property :aime_list, default: []

      def populate(parser)
        self.error_description = parser.error_description
        parser.aime_list.each do |a|
          aime = Aime.new
          aime.populate(a)
          aime_list.push(aime)
        end
      end

      def login_errors
        error_description.to_s.split("\n").map(&:strip).select {|s| s.starts_with?("・") }
      end
    end
  end
end
