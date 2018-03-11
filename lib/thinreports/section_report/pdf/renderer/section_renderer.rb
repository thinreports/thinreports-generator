module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf, section)
          @pdf = pdf
          @section = section
        end

        def render(section)
          doc = pdf.pdf

          box = doc.bounding_box([0, doc.cursor], width: 300) do
            section.items.each do |item|
              pdf.draw_shape_rect(item.internal)
            end
            doc.stroke_bounds
          end
          # box.move_past_bottom
          doc.move_down [section.schema.height, box.height].max
        end

        private

        attr_reader :pdf
      end
    end
  end
end
