module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf)
          @pdf = pdf
        end

        def render(section)
          doc = pdf.pdf

          y = doc.cursor
          y = section.schema.height if section.schema.type == 'footer' && section.schema.fixed_bottom?

          doc.bounding_box([0, y], width: doc.bounds.width, height: section.schema.height) do
            section.items.each do |item|
              draw_item(item)
            end
            doc.stroke_bounds
          end

          # bounding_box 実行完了後、doc.cursorの位置はbox末尾に移動する
          # https://github.com/prawnpdf/prawn/blob/master/lib/prawn/document/bounding_box.rb#L44
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
