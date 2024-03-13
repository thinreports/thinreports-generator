# frozen_string_literal: true

require_relative 'component'
require_relative 'stroke'
require_relative 'fill'

module Thinreports
  module SectionReport
    module Pdf
      class Rect
        include Component
        include Stroke
        include Fill

        attr_reader :pdf
        attr_accessor :x, :y, :width, :height
        attr_accessor :radius

        def initialize(pdf)
          @pdf = pdf
          @x, @y = 0, 0
          @width, @height = 0, 0
          @radius = 0
        end

        def draw
          pdf.fill_and_stroke do
            set_stroke
            set_fill

            if radius.positive?
              pdf.rounded_rectangle(point(x, y), width, height, radius)
            else
              pdf.rectangle(point(x, y), width, height)
            end
          end
        end

        def set_stroke
          return unless stroke?

          pdf.stroke_color(stroke_color)
          pdf.line_width(stroke_width)
          pdf.dash(stroke_dash_length, space: stroke_dash_space) if stroke_dash?
        end

        def set_fill
          pdf.fill_color(fill_color) if fill?
        end
      end
    end
  end
end
