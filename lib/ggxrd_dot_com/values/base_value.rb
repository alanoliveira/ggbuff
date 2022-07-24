# frozen_string_literal: true

module GgxrdDotCom
  module Values
    class BaseValue < Hashie::Dash
      include Hashie::Extensions::Dash::PropertyTranslation
    end
  end
end
