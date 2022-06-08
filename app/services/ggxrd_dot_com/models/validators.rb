# frozen_string_literal: true

module GgxrdDotCom
  module Models
    module Validators
      class IsAValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return if value.is_a?(options[:type])

          record.errors.add attribute, (options[:message] || "is not an #{options[:type]}")
        end
      end

      class NestedValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          valid = true
          Array(value).each do |v|
            valid &= v.valid?
          end
          record.errors.add attribute, (options[:message] || "have not valid elements") unless valid
        end
      end
    end
  end
end
