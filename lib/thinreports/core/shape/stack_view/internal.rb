# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        class Internal < Basic::Internal
          def initialize(parent, format)
            super
            @rows = []
          end

          attr_accessor :rows

          def type_of?(type_name)
            type_name == StackView::TYPE_NAME
          end
        end
      end
    end
  end
end
