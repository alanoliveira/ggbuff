# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Values::LoginResult do
  let(:instance) { described_class.new }

  describe "#login_errors" do
    subject(:login_errors) { instance.login_errors }

    let(:error_description) { "" }

    before { instance.error_description = error_description }

    context "when error_description have some errors" do
      let(:error_description) do
        <<-HEREDOC
      ログインに失敗しました。以下の原因が考えられます。
      ・アクセス過多のため、このID／ネットワークが制限されている。
      ・SEGA ID、パスワードが間違っている。
        HEREDOC
      end

      it do
        expect(login_errors).to contain_exactly(
          "・アクセス過多のため、このID／ネットワークが制限されている。",
          "・SEGA ID、パスワードが間違っている。"
        )
      end
    end

    context "when error_description is empty(nil)" do
      let(:error_description) { nil }

      it do
        expect(login_errors).to be_empty
      end
    end
  end
end
