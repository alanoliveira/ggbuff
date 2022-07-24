# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::PlayerSearchPage do
  describe "#result_list" do
    subject { described_class.new(html).result_list }

    context "when html file has a list of users", :aggregate_failures do
      let(:html) do
        <<-HTML
            <span style="font-size:small;">
              <div class="searchResultList"><a href="member_profile_view.php?user_id=111">GG PLAYER</a></div>
              <div class="searchResultList"><a href="member_profile_view.php?user_id=222">GG PLAYER</a></div>
              <div class="searchResultList"><a href="member_profile_view.php?user_id=333">GG SUPER PLAYER</a></div>
            </span>
        HTML
      end

      it { is_expected.to have(3).items.and all(be_a(GgxrdDotCom::Parsers::PlayerSearchResultDiv)) }
    end

    context "when passed html file not has a list of users" do
      let(:html) do
        <<-HTML.chomp
            <span style="font-size:small;">
              検索条件に一致するプレイヤーは見つかりませんでした。
            </div>
        HTML
      end

      it { is_expected.to be_empty }
    end
  end
end
