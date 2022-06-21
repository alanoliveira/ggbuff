# frozen_string_literal: true

class GgxrdApi
  delegate_missing_to :api

  def initialize(cookies=nil)
    cli = GgxrdDotCom::Client.new(cookies)
    @api = GgxrdDotCom::Api.new(cli)
  end

  private

  attr_reader :api
end
