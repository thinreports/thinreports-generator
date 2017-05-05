# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        class Interface < Basic::BlockInterface
          internal_delegators :format_enabled?

          # @param [Boolean] enabled
          # @return [self]
          def format_enabled(enabled)
            internal.format_enabled(enabled)
            self
          end

          # @param [Object] val
          # @param [Hash<Symbol, Object>] style_settings
          # @return [self]
          def set(val, style_settings = {})
            value(val)
            styles(style_settings) #=> self
          end

          private

          # @see Thinreports::Core::Shape::Base::Interface#init_internal
          def init_internal(parent, format)
            TextBlock::Internal.new(parent, format)
          end
        end
      end
    end
  end
end
