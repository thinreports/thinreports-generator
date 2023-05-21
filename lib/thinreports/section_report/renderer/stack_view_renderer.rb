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

        RowLayout = Struct.new(:row, :height, :top)

        def section_height(shape)
          row_layouts = build_row_layouts(shape.rows)

          total_row_height = row_layouts.sum(0, &:height)
          float_content_bottom = row_layouts
            .map { |l| row_renderer.calc_float_content_bottom(l.row) + l.top }
            .max.to_f

          [total_row_height, float_content_bottom].max
        end

        def render(shape)
          doc = pdf.pdf

          x, y, w = shape.format.attributes.values_at('x', 'y', 'width')
          doc.bounding_box([x, doc.bounds.height - y], width: w, height: section_height(shape)) do
            shape.rows.each do |row|
              row_renderer.render(row)
            end
          end
        end

        private

        attr_reader :pdf, :row_renderer

        def build_row_layouts(rows)
          row_layouts = rows.map { |row| RowLayout.new(row, row_renderer.section_height(row)) }

          row_layouts.inject(0) do |top, row_layout|
            row_layout.top = top
            top + row_layout.height
          end

          row_layouts
        end
      end
    end
  end
end
