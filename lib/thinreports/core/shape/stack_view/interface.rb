# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        class Interface < Basic::Interface
          private

          def init_internal(parent, format)
            StackView::Internal.new(parent, format)
          end
        end
      end
    end
  end
end
