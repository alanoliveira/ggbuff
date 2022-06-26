# frozen_string_literal: true

RSpec.shared_context "with logged in player" do
  include_context "with mocked api login methods"
  before { post "/login", params: {login: {sega_id: "sega_id", password: "password", remember_me: true}} }
end
