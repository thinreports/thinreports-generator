# frozen_string_literal: true

require_relative 'stack_view_renderer'
require_relative 'section_height'
require_relative 'draw_item'

module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        include SectionHeight
        include DrawItem

        def initialize(pdf)
          @pdf = pdf
        end

        def render(section)
          doc = pdf.pdf

          actual_height = section_height(section)
          doc.bounding_box([0, doc.cursor], width: doc.bounds.width, height: actual_height) do
            section.items.each do |item|
              draw_item(item, (actual_height - section.schema.height))
            end
          end
        end

        private

        attr_reader :pdf

        def stack_view_renderer
          @stack_view_renderer ||= Renderer::StackViewRenderer.new(pdf)
        end
      end
    end
  end
end
