# frozen_string_literal: true

FactoryBot.define do
  factory :login_form, class: "LoginForm" do
    sega_id { "player_1" }
    password { "123456" }
    remember_me { true }

    transient do
      api { GgxrdApi.new }
    end

    initialize_with { new(api, attributes) }
  end
end
