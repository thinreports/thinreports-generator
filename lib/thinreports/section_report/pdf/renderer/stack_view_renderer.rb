# frozen_string_literal: true

require_relative 'stack_view_row_renderer'

module Thinreports
  module SectionReport
    module Renderer
      class StackViewRenderer
        def initialize(pdf)
          @pdf = pdf
          @row_renderer = Renderer::StackViewRowRenderer.new(pdf)
        end

        def content_height(shape)
          sum = 0
          shape.rows.each do |row|
            sum += row_renderer.content_height(row)
          end
          sum
        end

        def render(shape)
          doc = pdf.pdf

          x, y, w = shape.format.attributes.values_at('x', 'y', 'width')
          doc.bounding_box([x, doc.bounds.height - y], width: w, height: content_height(shape)) do
            shape.rows.each do |row|
              row_renderer.render(row)
            end
            # doc.stroke_bounds
          end
        end

        private

        attr_reader :pdf, :row_renderer
      end
    end
  end
end
