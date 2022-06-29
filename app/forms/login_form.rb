# frozen_string_literal: true

class LoginForm < ApplicationForm
  attribute :sega_id, :string
  attribute :password, :string
  attribute :remember_me, :boolean

  attr_reader :result

  def initialize(params={})
    super(params)
  end

  def authenticate_api(api)
    return unless valid?

    @result = api.login(sega_id, password, remember_me)
  end

  validates :sega_id, :password, presence: true
  validate :result do
    Array(result&.login_errors).each do |e|
      errors.add :result, message: e
    end
  end
end
