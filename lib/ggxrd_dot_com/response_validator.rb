# frozen_string_literal: true

module GgxrdDotCom
  class ResponseValidator
    class ResponseError < StandardError; end
    class InMaintenanceError < ResponseError; end
    class NotAuthorizedError < ResponseError; end

    IN_MAINTENANCE_TEXT = "メンテナンス中は当サイトをご利用になれません。ご了承ください。"

    def initialize(response)
      @response = response
    end

    def validate!
      validate_not_in_maintenance!
      validate_not_unauthenticated!
    end

    private

    attr_reader :response

    def validate_not_in_maintenance!
      raise InMaintenanceError if response.body.include?(IN_MAINTENANCE_TEXT)
    end

    def validate_not_unauthenticated!
      body = response.body
      raise NotAuthorizedError if body.include?('<h2 class="">ログイン</h2>') &&
                                  body.exclude?('<div class="caution">')
    end
  end
end
