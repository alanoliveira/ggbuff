# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end

    context "with logged in player" do
      include_context "with logged in player"
      it "redirected to root url" do
        get "/login"
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "POST /login" do
    include_context "with mocked api login methods"
    let(:player) { create(:player) }

    it "returns http redirect" do
      post "/login", params: {login_form: {sega_id: "sega_id", password: "password", remember_me: true}}
      expect(response).to have_http_status(:redirect)
      expect(session).not_to be_empty
    end

    context "when parameters are invalid" do
      it "returns http unauthorized" do
        post "/login", params: {login_form: {sega_id: "", password: "", remember_me: true}}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /logout" do
    it "returns http redirect" do
      get "/logout"
      expect(response).to have_http_status(:redirect)
    end

    context "with logged in player" do
      include_context "with logged in player"
      it "redirected to root url" do
        get "/logout"
        expect(response).to have_http_status(:redirect)
        expect(session).to be_empty
      end
    end
  end
end
