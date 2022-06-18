# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::Aime do
  let(:instance) { described_class.new }

  describe "#url=" do
    subject { instance.url = url }
    let(:aime_id) { 1 }
    let(:url) { "/aime_key=#{aime_id}" }

    it { expect { subject }.to change { instance.id }.to(aime_id) }
  end
end
