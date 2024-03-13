# frozen_string_literal: true

require_relative 'section_height'
require_relative 'draw_item'

module Thinreports
  module SectionReport
    module Renderer
      class StackViewRowRenderer
        include SectionHeight
        include DrawItem

        def initialize(pdf)
          @pdf = pdf
        end

        def render(row)
          doc = pdf.pdf

          actual_height = section_height(row)
          doc.bounding_box([0, doc.cursor], width: doc.bounds.width, height: actual_height) do
            row.items.each do |item|
              draw_item(item, (actual_height - row.schema.height))
            end
          end
        end

        private

        attr_reader :pdf

        def stack_view_renderer
          raise Thinreports::Errors::InvalidLayoutFormat, 'nested StackView does not supported'
        end
      end
    end
  end
end
