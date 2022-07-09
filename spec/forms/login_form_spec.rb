# frozen_string_literal: true

require "rails_helper"

RSpec.describe LoginForm do
  let(:instance) { described_class.new(sega_id: "sega_id", password: "password") }

  describe "#authenticate_api" do
    subject(:authenticate_api) { instance.authenticate_api(api) }

    let(:login_result) { OpenStruct.new(login_errors: login_errors) }
    let(:login_errors) { [] }
    let(:api) { spy }

    before { allow(api).to receive(:login).and_return(login_result) }

    it do
      authenticate_api
      expect(instance).to be_valid
    end

    context "when api return some login error" do
      let(:login_errors) { ["error 1", "error 2"] }

      it do
        authenticate_api
        expect(instance).not_to be_valid
      end
    end
  end
end
