# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "unexpected html structure" do |invalid_html|
  context "when html has an unexpected structure" do
    let(:html) { invalid_html || "<htm></html>" }
    it { expect { subject }.to raise_error GgxrdDotCom::Parsers::UnexpectedStructureError }
  end
end
