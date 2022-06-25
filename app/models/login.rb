# frozen_string_literal: true

class Login
  include ActiveModel::Model
  attr_accessor :sega_id, :password, :remember_me
  attr_reader :login_result

  def authenticate_api(api)
    return unless valid?

    @login_result = api.login(sega_id, password, remember_me)
  end

  validates :sega_id, :password, presence: true
  validate :login_result do
    Array(login_result&.login_errors).each do |e|
      errors.add :login_result, message: e
    end
  end
end
