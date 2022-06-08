# frozen_string_literal: true

require "rails_helper"

RSpec.describe GgxrdDotCom::Models::PlayDate do
  describe ".create" do
    subject { described_class.create(date_string) }
    let(:date_string) { "" }

    context "when a string in the expected format used" do
      let(:date_string) { "12/31 20:10" }

      it do
        is_expected.to have_attributes(month: 12, day: 31, hour: 20, minute: 10)
      end
    end

    context "when a string in a unexpected format used" do
      let(:date_string) { "2020-01-01 20:10" }

      it do
        is_expected.to have_attributes(month: nil, day: nil, hour: nil, minute: nil)
      end
    end
  end

  describe "#to_date_time" do
    subject { described_class.new(month: month, day: day, hour: hour, minute: minute).to_date_time }

    shared_examples_for "when the attributes have have a valid date" do
      it { is_expected.to be_a(DateTime).and have_attributes(month: month, day: day, hour: hour, minute: minute) }
    end

    context "when the date is Feb 29" do
      let(:month) { 2 }
      let(:day) { 29 }
      let(:hour) { 0 }
      let(:minute) { 0 }
      it_behaves_like "when the attributes have have a valid date"
    end

    context "when the attributes not have a valid date" do
      let(:month) { 13 }
      let(:day) { 1 }
      let(:hour) { 0 }
      let(:minute) { 0 }
      it { is_expected.to be_nil }
    end
  end
end
