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

  describe "#set_locale" do
    before do
      I18n.available_locales = %i[en ja pt]
      I18n.default_locale = :ja
    end

    it do
      I18n.with_locale(:pt) do
        expect { subject.set_locale }.to change { I18n.locale }.to(I18n.default_locale)
      end
    end

    context "when param locale is used" do
      before do
        controller.params[:locale] = :en
        request.headers["Accept-Language"] = "ja-JP;q=0.8,ja;q=0.7,pt-BR;q=0.6,pt;q=0.5"
      end

      it do
        I18n.with_locale(:pt) do
          expect { subject.set_locale }.to change { I18n.locale }.to(:en)
        end
      end
    end

    context "when header param locale is not used but 'Accept-Language' header is present" do
      before do
        controller.request.headers["Accept-Language"] = "en-US,en;q=0.9,ja-JP;q=0.8,ja;q=0.7,pt-BR;q=0.6,pt;q=0.5"
      end

      it do
        I18n.with_locale(:pt) do
          expect { subject.set_locale }.to change { I18n.locale }.to(:en)
        end
      end
    end
  end

  describe "#locale_from_accept_language" do
    before do
      I18n.available_locales = %i[ja pt]
      controller.request.headers["Accept-Language"] = "en-US,en;q=0.9,ja-JP;q=0.8,ja;q=0.7,pt-BR;q=0.6,pt;q=0.5"
    end

    it { expect(subject.locale_from_accept_language).to eq :ja }

    context "when Accept-Language header is not present" do
      before { controller.request.headers["Accept-Language"] = nil }

      it { expect(subject.locale_from_accept_language).to be nil }
    end

    context "when Accept-Language header present but there is no supported language" do
      before do
        I18n.available_locales = %i[fr it]
        controller.request.headers["Accept-Language"] = "en-US,en;q=0.9,ja-JP;q=0.8,ja;q=0.7,pt-BR;q=0.6,pt;q=0.5"
      end

      it { expect(subject.locale_from_accept_language).to be nil }
    end
  end
end
