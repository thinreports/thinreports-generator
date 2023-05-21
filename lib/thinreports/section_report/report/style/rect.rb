# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Report
      module Style
        class Rect < Style::Base
          style :border_color, 'border-color'
          style :border_width, 'border-width'
          style :border_style, 'border-style'
          style :fill_color, 'fill-color'

          def border
            [border_width, border_color]
          end

          def border=(width_and_color)
            self.border_width, self.border_color = width_and_color
          end
        end
      end
    end
  end
end
