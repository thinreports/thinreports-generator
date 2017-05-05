# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        module Formatter
          class Datetime < Formatter::Basic
            private

            def apply_format_to(value)
              value.strftime(format.format_datetime_format)
            end

            def applicable?(value)
              !blank_value?(format.format_datetime_format) && value.respond_to?(:strftime)
            end
          end
        end
      end
    end
  end
end
