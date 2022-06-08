# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class ProfileUrl < BaseModel
      attr_accessor :url

      def id
        url.scan(/\d+$/).last&.to_i
      end

      validates :url, presence: true, format: {with: %r{http://.+member_profile_view.php?user_id=\d+}}
    end
  end
end
