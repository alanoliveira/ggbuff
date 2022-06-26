# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Values::ProfileUrl do
  let(:instance) { described_class.new }

  describe "#id" do
    subject { instance.id }

    before { instance.url = profile_url }

    context "when a valid url used" do
      let(:profile_url) { "http://www.ggxrd.com/pg2/member_profile_view.php?user_id=#{player_id}" }
      let(:player_id) { "19085" }

      it do
        is_expected.to eq player_id
      end
    end

    context "when a invalid url used" do
      let(:profile_url) { "http://www.ggxrd.com/pg2/hogehoge" }

      it do
        is_expected.to be_nil
      end
    end
  end
end
