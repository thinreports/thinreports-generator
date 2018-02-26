module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf)
          @pdf = pdf
        end

        def content_height(section)
          text_items = section.items.select { |s| s.internal.type_of?(Core::Shape::TextBlock::TYPE_NAME) && s.internal.style.finalized_styles['overflow'] == 'expand' }
          p text_items.map{|item|
            height = 0
            @pdf.draw_shape_tblock(item.internal) { |array, options|
              page_height = @pdf.pdf.bounds.height
              modified_options = options.merge(at:[0, page_height], height: page_height)
              height = @pdf.pdf.height_of_formatted(array, modified_options)
            }
            height
          }.max
          section.schema.height
        end

        def render(section)
          doc = pdf.pdf

          doc.bounding_box([0, doc.cursor], width: doc.bounds.width, height: section.schema.height) do
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
