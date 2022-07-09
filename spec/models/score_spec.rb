# frozen_string_literal: true

require "rails_helper"

RSpec.describe Score do
  describe "#loses" do
    subject { instance.loses }

    let(:instance) { described_class.new(wins: 10, total: 15) }

    it { is_expected.to eq 5 }
  end
end
