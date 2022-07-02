# frozen_string_literal: true

require "spec_helper"

RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = false
end

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

  describe "#require_player" do
    controller do
      def index
        render html: ""
      end
    end

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

  describe "#require_player" do
    controller do
      def index
        render html: "", template: true
      end
    end

    context "when player is not logged in" do
      it do
        get :index
        expect(flash).to be_empty
      end
    end

    context "when player is logged in and there is no previous matches_load_process" do
      before { session[:player_id] = create(:player).id }

      it do
        get :index
        expect(flash).to be_empty
      end
    end
  end

  describe "#flash_matches_loader_status" do
    controller do
      skip_before_action :require_player
      def index
        render html: "", template: true
      end
    end

    context "when player the previous player matches_load_process state is finished" do
      before do
        player = create(:player)
        session[:player_id] = player.id
        create(:matches_load_process, player: player, state: :finished)
      end

      it do
        get :index
        expect(flash).to be_empty
      end
    end

    context "when player the previous player matches_load_process not ended" do
      before do
        player = create(:player)
        session[:player_id] = player.id
        create(:matches_load_process, player: player, state: :created)
      end

      it do
        get :index
        expect(flash[:warning]).not_to be_empty
      end
    end

    context "when player the previous player matches_load_process had error" do
      before do
        player = create(:player)
        session[:player_id] = player.id
        create(:matches_load_process, player: player, state: :error)
      end

      it do
        get :index
        expect(flash[:danger]).not_to be_empty
      end
    end
  end

  describe "rescue_from GgxrdDotCom::Client::InMaintenanceError" do
    controller do
      skip_before_action :require_player
      def index
        raise GgxrdDotCom::Client::InMaintenanceError
      end
    end

    it do
      get :index
      expect(flash).not_to be_empty
    end
  end

  describe "rescue_from GgxrdDotCom::Client::NotAuthenticatedError" do
    before { session[:player_id] = create(:player).id }
    controller do
      skip_before_action :require_player
      def index
        raise GgxrdDotCom::Client::NotAuthenticatedError
      end
    end

    it do
      get :index
      expect(session[:player_id]).to be_nil
      expect(flash).not_to be_empty
    end
  end
end
