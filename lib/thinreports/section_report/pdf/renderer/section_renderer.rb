module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf)
          @pdf = pdf
        end

        def render(section)
          doc = pdf.pdf

          box = doc.bounding_box([0, doc.cursor], width: 300, height: section.schema.height) do
            section.items.each do |item|
              draw_item(item)
            end
            # doc.stroke_bounds
          end
        end

        private

        attr_reader :pdf

        def draw_item(item)
          shape = item.internal
          if shape.type_of?(Core::Shape::TextBlock::TYPE_NAME)
            @pdf.draw_shape_tblock(shape)
          elsif shape.type_of?('line')
            @pdf.draw_shape_line(shape)
          else
            puts 'unknown shape type'
          end
        end
      end
    end
  end
end
