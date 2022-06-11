# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::PlayerSearch::Result do
  let(:instance) { described_class.new }

  describe "#profile_url=" do
    subject { instance.profile_url = url }
    let(:url) { "member_profile_view.php?user_id=1" }

    it { expect { subject }.to change { instance.profile_url }.to(a_kind_of(GgxrdDotCom::Models::ProfileUrl)) }
  end
end
