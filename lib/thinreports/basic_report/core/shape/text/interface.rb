# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Core
      module Shape
        module Text
          class Interface < Basic::Interface
            private

            # @see Thinreports::BasicReport::Core::Shape::Base::Interface#init_internal
            def init_internal(parent, format)
              Text::Internal.new(parent, format)
            end
          end
        end
      end
    end
  end
end
