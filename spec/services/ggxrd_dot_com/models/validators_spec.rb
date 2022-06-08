# frozen_string_literal: true

RSpec.describe GgxrdDotCom::Models::Validators::IsAValidator do
  subject { described_class.new(type: Array, attributes: {any: true}) }

  describe "#validate_each" do
    let(:errors) { ActiveModel::Errors.new(Object.new) }
    let(:record) { instance_double(ActiveModel::Validations, errors: errors) }

    context "when validated object is an array" do
      it { expect { subject.validate_each(record, :my_array, []) }.to_not change(errors, :count) }
    end

    context "when validated object is not an array" do
      it { expect { subject.validate_each(record, :my_array, "not array") }.to change(errors, :count) }
    end
  end
end

RSpec.describe GgxrdDotCom::Models::Validators::NestedValidator do
  subject { described_class.new(attributes: {any: true}) }

  describe "#validate_each" do
    let(:errors) { ActiveModel::Errors.new(Object.new) }
    let(:record) { instance_double(ActiveModel::Validations, errors: errors) }

    context "when validated object is valid" do
      let(:nested_item) { instance_double(ActiveModel::Validations, valid?: true) }
      it { expect { subject.validate_each(record, :nested, nested_item) }.to_not change(errors, :count) }
    end

    context "when validated object not is valid" do
      let(:nested_item) { instance_double(ActiveModel::Validations, valid?: false) }
      it { expect { subject.validate_each(record, :nested, nested_item) }.to change(errors, :count) }
    end

    context "when validated object is an array with valid elements" do
      let(:nested_item) { instance_double(ActiveModel::Validations, valid?: true) }
      it { expect { subject.validate_each(record, :nested_list, [nested_item]) }.not_to change(errors, :count) }
    end

    context "when validated object is an array with invalid elements" do
      let(:nested_item) { instance_double(ActiveModel::Validations, valid?: false) }
      it { expect { subject.validate_each(record, :nested_list, [nested_item]) }.to change(errors, :count) }
    end
  end
end
