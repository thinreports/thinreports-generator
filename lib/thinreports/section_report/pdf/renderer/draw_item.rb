module Thinreports
  module SectionReport
    module Renderer
      module DrawItem
        def draw_item(item, expanded_height = 0)
          shape = item.internal

          # overflow: 'expand' の場合は height が無視されてしまうので、follow-expand: 'height' の時は描画時のみ無視する
          ignore_overflow = item.internal.format.attributes['follow-expand'] == 'height'

          if shape.type_of?(Core::Shape::TextBlock::TYPE_NAME)
            case shape.format.follow_expand
            when 'height'
              # セクションにあわせて伸びる
              pdf.draw_shape_tblock(shape, expanded_height, ignore_overflow: ignore_overflow)
            else
              pdf.draw_shape_tblock(shape, ignore_overflow: ignore_overflow)
            end
          elsif shape.type_of?(Core::Shape::ImageBlock::TYPE_NAME)
            pdf.draw_shape_iblock(shape)
          elsif shape.type_of?('text')
            case shape.format.follow_expand
            when 'height'
              # セクションにあわせて伸びる
              pdf.draw_shape_text(shape, expanded_height)
            else
              pdf.draw_shape_text(shape)
            end
          elsif shape.type_of?('image')
            pdf.draw_shape_image(shape)
          elsif shape.type_of?('ellipse')
            pdf.draw_shape_ellipse(shape)
          elsif shape.type_of?('rect')
            case shape.format.follow_expand
            when 'height'
              # セクションにあわせて伸びる
              pdf.draw_shape_rect(shape, expanded_height)
            else
              pdf.draw_shape_rect(shape)
            end
          elsif shape.type_of?('line')
            case shape.format.follow_expand
            when 'height'
              # セクションにあわせて伸びる
              y1, y2 = shape.format.attributes.values_at('y1', 'y2')
              if y1 < y2
                pdf.draw_shape_line(shape, 0, expanded_height)
              else
                pdf.draw_shape_line(shape, expanded_height, 0)
              end
            when 'y'
              # セクションにあわせて描画位置をずらす
              pdf.draw_shape_line(shape, expanded_height, expanded_height)
            else
              pdf.draw_shape_line(shape)
            end
          elsif shape.type_of?(Core::Shape::StackView::TYPE_NAME)
            stack_view_renderer.render(shape)
          else
            puts 'unknown shape type'
          end
        end
      end
    end
  end
end
