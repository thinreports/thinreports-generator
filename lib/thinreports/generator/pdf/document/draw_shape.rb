# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module DrawShape
        # @param [Thinreports::Core::Shape::TextBlock::Internal] shape
        def draw_shape_tblock(shape, &block)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')

          content = shape.real_value.to_s
          return if content.empty?

          attrs = build_text_attributes(shape.style.finalized_styles)

          unless shape.multiple?
            content = content.tr("\n", ' ')
            attrs[:single] = true
          end

          text_box(content, x, y, w, h, attrs, &block)
        end

        def draw_shape_pageno(shape, page_no, page_count)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')

          attrs = build_text_attributes(shape.style.finalized_styles)
          text_box(shape.build_format(page_no, page_count), x, y, w, h, attrs)
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_image(shape)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')

          image_data = shape.format.attributes['data']
          base64image(image_data['base64'], x, y, w, h)
        end

        # @param [Thinreports::Core::Shape::ImageBlock::Internal] shape
        def draw_shape_iblock(shape)
          return if blank_value?(shape.src)

          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          style = shape.style.finalized_styles

          image_box(
            shape.src, x, y, w, h,
            position_x: image_position_x(style['position-x']),
            position_y: image_position_y(style['position-y'])
          )
        end

        # @param [Thinreports::Core::Shape::Text::Internal] shape
        def draw_shape_text(shape)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          text(
            shape.texts.join("\n"), x, y, w, h,
            build_text_attributes(shape.style.finalized_styles)
          )
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_ellipse(shape)
          cx, cy, rx, ry = shape.format.attributes.values_at('cx', 'cy', 'rx', 'ry')
          ellipse(cx, cy, rx, ry, build_graphic_attributes(shape.style.finalized_styles))
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_line(shape)
          x1, y1, x2, y2 = shape.format.attributes.values_at('x1', 'y1', 'x2', 'y2')
          line(x1, y1, x2, y2, build_graphic_attributes(shape.style.finalized_styles))
        end

        # @param [Thinreports::Core::Shape::Basic::Internal] shape
        def draw_shape_rect(shape)
          x, y, w, h = shape.format.attributes.values_at('x', 'y', 'width', 'height')
          rect_attributes = build_graphic_attributes(shape.style.finalized_styles) do |attrs|
            attrs[:radius] = shape.format.attributes['rx']
          end
          rect(x, y, w, h, rect_attributes)
        end
      end
    end
  end
end
