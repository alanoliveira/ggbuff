# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Client do
  let(:instance) { described_class.new }
  let(:response) { instance_double(HTTParty::Response, body: body) }

  before { allow(described_class).to receive(:send).and_return(response) }

  shared_examples "in maintenance" do
    let(:body) do
      <<-HTML
        <div>
        <p class="errorText">
        当サイトは04:00から08:00まで定期メンテナンス時間となっております。メンテナンス中は当サイトをご利用になれません。ご了承ください。
        </p>
        </div>
      HTML
    end

    it { expect { subject }.to raise_error GgxrdDotCom::Client::InMaintenanceError }
  end

  describe "#index" do
    subject { instance.index }

    include_examples "in maintenance"
  end
end
