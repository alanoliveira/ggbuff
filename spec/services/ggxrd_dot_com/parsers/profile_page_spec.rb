# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Parsers::ProfilePage do
  describe "#player_name" do
    subject { described_class.new(html).player_name }

    let(:html) do
      <<-HTML.chomp
            <div>
              <dd class="field show player_name">#{player_name} [<a href="player_name_edit.php">変更</a>]</dd>
            </div>
      HTML
    end

    context "when player_name exists" do
      let(:player_name) { "GG BAIKEN PLAYER" }
      it { is_expected.to eq(player_name) }
    end

    context "when player_name is blank" do
      let(:player_name) { "" }
      it { is_expected.to eq("") }
    end

    include_examples "unexpected html structure", <<-HTML.chomp
      <div>
        <dd class="field show">GG PLAYER [<a href="player_name_edit.php">変更</a>]</dd>
      </div>
    HTML
  end
end
