# frozen_string_literal: true

require_relative 'rect'

module Thinreports
  module SectionReport
    module Pdf
      class Document
        def draw_rect(&block)
          Rect.new(pdf).tap(&block).draw
        end

        def draw_line
        end

        def draw_ellipse
        end

        def draw_text
        end

        def draw_text_block
        end

        def draw_image
        end

        def draw_image_block
        end

        def section(height, &block)
          pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: height, &block)
        end
      end
    end
  end
end
