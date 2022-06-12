# frozen_string_literal: true

FactoryBot.define do
  factory :ggxrd_dot_com_profile, class: GgxrdDotCom::Models::Profile do
    sequence(:player_name, "GG PLAYER 1")

    initialize_with { new(attributes) }
  end
end
