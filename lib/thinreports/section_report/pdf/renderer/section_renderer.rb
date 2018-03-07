module Thinreports
  module SectionReport
    module Renderer
      class SectionRenderer
        def initialize(pdf)
          @pdf = pdf
        end

        def content_height(section)
          return section.schema.height unless section.schema.auto_expand?

          text_items = section.items.select do |s|
            s.internal.type_of?(Core::Shape::TextBlock::TYPE_NAME) && s.internal.style.finalized_styles['overflow'] == 'expand'
          end

          return section.schema.height if text_items.empty?

          [text_items_max_height(section, text_items), section.schema.height].max
        end

        def render(section)
          doc = pdf.pdf

          actual_height = content_height(section)
          doc.bounding_box([0, doc.cursor], width: doc.bounds.width, height: actual_height) do
            section.items.each do |item|
              draw_item(item, (actual_height - section.schema.height))
            end
            # doc.stroke_bounds
          end

          # bounding_box 実行完了後、doc.cursorの位置はbox末尾に移動する
          # https://github.com/prawnpdf/prawn/blob/master/lib/prawn/document/bounding_box.rb#L44
        end

        private

        attr_reader :pdf

        def draw_item(item, expanded_height = 0)
          shape = item.internal
          if shape.type_of?(Core::Shape::TextBlock::TYPE_NAME)
            @pdf.draw_shape_tblock(shape)
          elsif shape.type_of?(Core::Shape::ImageBlock::TYPE_NAME)
            @pdf.draw_shape_iblock(shape)
          elsif shape.type_of?('text')
            @pdf.draw_shape_text(shape)
          elsif shape.type_of?('image')
            @pdf.draw_shape_image(shape)
          elsif shape.type_of?('ellipse')
            @pdf.draw_shape_ellipse(shape)
          elsif shape.type_of?('rect')
            case shape.format.follow_expand
              when 'height'
                # セクションにあわせて伸びる
                @pdf.draw_shape_rect(shape, expanded_height)
              else
                @pdf.draw_shape_rect(shape)
            end
          elsif shape.type_of?('line')
            case shape.format.follow_expand
              when 'height'
                # セクションにあわせて伸びる
                y1, y2 = shape.format.attributes.values_at('y1', 'y2')
                if y1 < y2
                  @pdf.draw_shape_line(shape, 0, expanded_height)
                else
                  @pdf.draw_shape_line(shape, expanded_height, 0)
                end
              when 'y'
                # セクションにあわせて描画位置をずらす
                @pdf.draw_shape_line(shape, expanded_height, expanded_height)
              else
                @pdf.draw_shape_line(shape)
            end
          else
            puts 'unknown shape type'
          end
        end

        def text_items_max_height(section, text_items)
          text_items.map do |item|
            height = 0
            @pdf.draw_shape_tblock(item.internal) { |array, options|
              page_height = @pdf.pdf.bounds.height
              modified_options = options.merge(at: [0, page_height], height: page_height)
              height = @pdf.pdf.height_of_formatted(array, modified_options)
            }
            height + section.schema.height - item.internal.format.attributes['height']
          end.max
        end
      end
    end
  end
end
