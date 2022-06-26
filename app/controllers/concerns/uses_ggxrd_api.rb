# frozen_string_literal: true

module UsesGgxrdApi
  extend ActiveSupport::Concern

  def ggxrd_api
    @ggxrd_api ||= GgxrdApi.new(session[:ggxrd_cookies])
  end
end
