# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::LoginResult do
  let(:instance) { described_class.new(error_description: error_description) }

  describe "#login_errors" do
    subject { instance.login_errors }

    context "when error_description have some errors" do
      let(:error_description) do
        <<-HEREDOC
      ログインに失敗しました。以下の原因が考えられます。<br>
      ・アクセス過多のため、このID／ネットワークが制限されている。<br>
      ・SEGA ID、パスワードが間違っている。
        HEREDOC
      end

      it do
        is_expected.to contain_exactly(
          "・アクセス過多のため、このID／ネットワークが制限されている。",
          "・SEGA ID、パスワードが間違っている。"
        )
      end
    end

    context "when error_description is empty(nil)" do
      let(:error_description) { nil }

      it do
        is_expected.to be_empty
      end
    end
  end
end
