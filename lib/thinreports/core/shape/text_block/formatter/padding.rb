# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        module Formatter
          class Padding < Formatter::Basic
            private

            def apply_format_to(value)
              value.to_s.send(format.format_padding_rdir? ? :ljust : :rjust,
                              format.format_padding_length,
                              format.format_padding_char)
            end

            def applicable?(_value)
              !blank_value?(format.format_padding_char) && format.format_padding_length > 0
            end
          end
        end
      end
    end
  end
end
