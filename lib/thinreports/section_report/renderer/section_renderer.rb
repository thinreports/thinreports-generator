# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf, section)
          @pdf = pdf
          @section = section
        end

        def render
          actual_height = section.height

          pdf.section(section.height) do
            section.items.each do |item|
              item.render(pdf)
            end
          end

          pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: actual_height) do
            section.items.each do |item|
              item.render(pdf, expanded_height: actual_height - section.schema.height)
            end
          end
        end

        private

        attr_reader :pdf, :section
      end
    end
  end
end
