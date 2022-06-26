# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Values::Aime do
  let(:instance) { described_class.new }

  describe "#id" do
    subject { instance.id }
    let(:aime_id) { "1" }
    let(:url) { "/aime_key=#{aime_id}" }

    before { instance.url = url }

    it { is_expected.to eq aime_id }
  end
end
