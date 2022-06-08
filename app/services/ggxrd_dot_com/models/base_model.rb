# frozen_string_literal: true

module GgxrdDotCom
  module Models
    class BaseModel
      include ActiveModel::Validations
      include Validators

      def initialize(attributes={})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
    end
  end
end
