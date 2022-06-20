# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::LoginResultPage do
  describe "#error_description" do
    subject { described_class.new(html).error_description }

    context "when login succeed", :aggregate_failures do
      let(:html) { "" }

      it { is_expected.to be_empty }
    end

    context "when login has some error" do
      let(:html) do
        <<~HTML.chomp
          <div class="loginBox">
            <div class="caution">
            ログインに失敗しました。以下の原因が考えられます。<br>
            ・アクセス過多のため、このID／ネットワークが制限されている。<br>
            ・SEGA ID、パスワードが間違っている。
            </div>
          </div>
        HTML
      end

      it do
        is_expected.to include("ログインに失敗しました。以下の原因が考えられます。")
          .and include("・アクセス過多のため、このID／ネットワークが制限されている。")
          .and include("・SEGA ID、パスワードが間違っている。")
        is_expected.not_to match(%r{<br/?>}) # xpath(...).text remove the <br>
      end
    end
  end

  describe "#aime_list" do
    subject { described_class.new(html).aime_list }

    context "when html file has a list of aime cards", :aggregate_failures do
      # TODO: Improve this when get a semple of aime selection page
      let(:html) do
        <<-HTML
        <a href="/aime_key=1">Aime1</a>
        <a href="/aime_key=2">Aime2</a>
        <a href="/aime_key=3">Aime3</a>
        HTML
      end

      it { is_expected.to have(3).items.and all(be_a(GgxrdDotCom::Parsers::AimeSelectionAnchor)) }
    end

    context "when passed html file not has a list of users" do
      let(:html) { "" }

      it { is_expected.to be_empty }
    end
  end
end
