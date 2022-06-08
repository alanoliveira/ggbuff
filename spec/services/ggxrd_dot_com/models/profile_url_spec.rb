# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::ProfileUrl do
  describe "#id" do
    subject { described_class.new(url: profile_url).id }

    context "when a valid url used" do
      let(:profile_url) { "http://www.ggxrd.com/pg2/member_profile_view.php?user_id=#{player_id}" }
      let(:player_id) { 19_085 }

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
