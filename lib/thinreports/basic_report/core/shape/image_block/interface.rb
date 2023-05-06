# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Core
      module Shape
        module ImageBlock
          class Interface < Basic::BlockInterface
            # @see #value
            alias src value
            # @see #value=
            alias src= value=

            private

            # @see Thinreports::BasicReport::Core::Shape::Base::Interface#init_internal
            def init_internal(parent, format)
              ImageBlock::Internal.new(parent, format)
            end
          end
        end
      end
    end
  end
end
