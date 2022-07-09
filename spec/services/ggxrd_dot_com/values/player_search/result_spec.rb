# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Values::PlayerSearch::Result do
  let(:instance) { described_class.new }

  describe "#profile_url" do
    subject(:profile_url) { instance.profile_url }

    let(:url) { "member_profile_view.php?user_id=1" }

    before { instance.profile_url = url }

    it { expect(profile_url).to be_a(GgxrdDotCom::Values::ProfileUrl) }
  end
end
