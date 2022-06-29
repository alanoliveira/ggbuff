# frozen_string_literal: true

require "spec_helper"

RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = false
end

describe ApplicationController, type: :controller do
  controller do
    def index
      render html: ""
    end
  end

  describe "#current_player" do
    context "when player is logged in" do
      let!(:player) { create(:player) }

      before { session[:player_id] = player.id }

      it { expect(subject.current_player).to eq player }
    end

    context "when player is not logged in" do
      it { expect(subject.current_player).to be_nil }
    end
  end

  describe "#player_signed_in?" do
    context "when player is logged in" do
      before { allow(subject).to receive(:current_player).and_return(create(:player)) }

      it { expect(subject.player_signed_in?).to be true }
    end

    context "when player is not logged in" do
      it { expect(subject.player_signed_in?).to be false }
    end
  end

  describe "#require_player" do
    context "when player is logged in" do
      before { session[:player_id] = create(:player).id }
      it do
        get :index
        expect(response).not_to be_redirect
      end
    end

    context "when player is not logged in" do
      it do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
end
