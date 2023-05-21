# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Renderer
      class RectRenderer
        def initialize(pdf, rect)
          @pdf = pdf
          @rect = rect
        end

        def render
          pdf.draw_rect { |r|
            r.x = rect.x
            r.y = rect.y
            r.width = rect.width
            r.height = rect.height
            r.stroke_style = rect.style.border_style
            r.stroke_color = rect.style.border_color
            r.stroke_width = rect.style.border_width
            r.fill_color = rect.style.fill_color
            r.radius = rect.border_radius
          }
        end

        private

        attr_reader :pdf, :rect
      end
    end
  end
end
