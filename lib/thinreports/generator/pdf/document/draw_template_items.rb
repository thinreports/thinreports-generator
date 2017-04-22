# coding: utf-8

module Thinreports
  module Generator

    module PDF::DrawTemplateItems
      # @param [Array<Hash>] items
      def draw_template_items(items)
        items.each do |item_attributes|
          next unless drawable?(item_attributes)

          case item_attributes['type']
          when 'text' then draw_text(item_attributes)
          when 'image' then draw_image(item_attributes)
          when 'rect' then draw_rect(item_attributes)
          when 'ellipse' then draw_ellipse(item_attributes)
          when 'line' then draw_line(item_attributes)
          end
        end
      end

      private

      # @param [Hash] item_attributes
      def draw_rect(item_attributes)
        x, y, w, h = item_attributes.values_at('x', 'y', 'width', 'height')
        graphic_attributes = build_graphic_attributes(item_attributes['style']) do |attrs|
          attrs[:radius] = item_attributes['rx']
        end

        rect(x, y, w, h, graphic_attributes)
      end

      # @see #draw_rect
      def draw_ellipse(item_attributes)
        x, y, rx, ry = item_attributes.values_at('cx', 'cy', 'rx', 'ry')
        ellipse(x, y, rx, ry, build_graphic_attributes(item_attributes['style']))
      end

      # @see #draw_rect
      def draw_line(item_attributes)
        x1, y1, x2, y2 = item_attributes.values_at('x1', 'y1', 'x2', 'y2')
        line(x1, y1, x2, y2, build_graphic_attributes(item_attributes['style']))
      end

      # @see #draw_rect
      def draw_text(item_attributes)
        x, y, w, h = item_attributes.values_at('x', 'y', 'width', 'height')
        text(item_attributes['texts'].join("\n"), x, y, w, h, build_text_attributes(item_attributes['style']))
      end

      # @see #draw_rect
      def draw_image(item_attributes)
        x, y, w, h = item_attributes.values_at('x', 'y', 'width', 'height')
        image_data = item_attributes['data']

        base64image(image_data['base64'], x, y, w, h)
      end

      def drawable?(item_attributes)
        item_attributes['id'].empty? && item_attributes['display']
      end
    end

  end
end
