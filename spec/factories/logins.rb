# frozen_string_literal: true

FactoryBot.define do
  factory :login, class: Login do
    sega_id { "player_1" }
    password { "123456" }
    remember_me { true }

    initialize_with { new(attributes) }
  end
end
