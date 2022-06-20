# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::ResponseValidator do
  let(:instance) { described_class.new(response) }
  let(:response) { instance_double(HTTParty::Response, body: body) }

  describe "#validate!" do
    subject { instance.validate! }

    context "when ggxrd.com is in maintenance" do
      let(:body) do
        <<-HTML
        <div>
        <p class="errorText">
        当サイトは04:00から08:00まで定期メンテナンス時間となっております。メンテナンス中は当サイトをご利用になれません。ご了承ください。
        </p>
        </div>
        HTML
      end

      it { expect { subject }.to raise_error GgxrdDotCom::ResponseValidator::InMaintenanceError }
    end

    context "when request is not authenticated" do
      let(:body) do
        <<~HTML
          <h2 class="">ログイン</h2>
          <input type="text" name="login_id" value="" class="textInput">
          <input type="password" name="password" value="" class="textInput">
        HTML
      end

      it { expect { subject }.to raise_error GgxrdDotCom::ResponseValidator::NotAuthorizedError }
    end

    context "when response is a username/password error" do
      let(:body) do
        <<~HTML
          <h2 class="">ログイン</h2>
          <div class="caution">ログインに失敗しました。以下の原因が考えられます。</div>
          <input type="text" name="login_id" value="" class="textInput">
          <input type="password" name="password" value="" class="textInput">
        HTML
      end

      it { expect { subject }.not_to raise_error }
    end
  end
end
