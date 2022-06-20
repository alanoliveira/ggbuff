# frozen_string_literal: true

require "spec_helper"

describe ApplicationController, type: :controller do
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
end
