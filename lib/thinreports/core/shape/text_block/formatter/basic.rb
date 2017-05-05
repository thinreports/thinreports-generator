# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        module Formatter
          class Basic
            include Utils

            attr_reader :format

            def initialize(format)
              @format = format
            end

            def apply(value)
              value = apply_format_to(value) if applicable?(value)

              return value if blank_value?(format.format_base)

              format.format_base.gsub(/\{value\}/, value.to_s)
            end

            private

            def apply_format_to(value)
              value
            end

            def applicable?(_value)
              true
            end
          end
        end
      end
    end
  end
end
