# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Renderer
      module SectionHeight
        LayoutInfo = Struct.new(:shape, :content_height, :top_margin, :bottom_margin)

        def section_height(section)
          return [section.min_height || 0, section.schema.height].max if !section.schema.auto_stretch? || section.items.empty?

          item_layouts = section.items.map { |item| item_layout(section, item.internal) }.compact

          min_bottom_margin = item_layouts.each_with_object([]) do |l, margins|
            margins << l.bottom_margin if l.shape.format.affect_bottom_margin?
          end.min.to_f

          max_content_bottom = item_layouts.each_with_object([]) do |l, bottoms|
            bottoms << l.top_margin + l.content_height if l.shape.format.affect_bottom_margin?
          end.max.to_f

          [section.min_height || 0, max_content_bottom + min_bottom_margin].max
        end

        def calc_float_content_bottom(section)
          item_layouts = section.items.map { |item| item_layout(section, item.internal) }.compact
          item_layouts
            .map { |l| l.top_margin + l.content_height }
            .max.to_f
        end

        def item_layout(section, shape)
          if shape.type_of?(Core::Shape::TextBlock::TYPE_NAME)
            text_layout(section, shape)
          elsif shape.type_of?(Core::Shape::StackView::TYPE_NAME)
            stack_view_layout(section, shape)
          elsif shape.type_of?(Core::Shape::ImageBlock::TYPE_NAME)
            image_block_layout(section, shape)
          elsif shape.type_of?('ellipse')
            cy, ry = shape.format.attributes.values_at('cy', 'ry')
            static_layout(section, shape, cy - ry, ry * 2)
          elsif shape.type_of?('line')
            y1, y2 = shape.format.attributes.values_at('y1', 'y2')
            static_layout(section, shape, [y1, y2].min, (y2 - y1).abs)
          else
            y, height = shape.format.attributes.values_at('y', 'height')
            raise ArgumentError.new("Unknown layout for #{shape}") if height == nil || y == nil
            static_layout(section, shape, y, height)
          end
        end

        def static_layout(section, shape, y, height)
          LayoutInfo.new(shape, height, y, section.schema.height - height - y)
        end

        def image_block_layout(section, shape)
          y, height = shape.format.attributes.values_at('y', 'height')
          if shape.style.finalized_styles['position-y'] == 'top'
            dimensions = pdf.shape_iblock_dimenions(shape)
            content_height = dimensions ? dimensions[1] : 0

            LayoutInfo.new(shape, content_height, y, section.schema.height - height - y)
          else
            static_layout(section, shape, y, height)
          end
        end

        def calc_text_block_height(shape)
          height = 0

          pdf.draw_shape_tblock(shape) do |array, options|
            modified_options = options.merge(at: [0, 10_000], height: 10_000)
            height = pdf.pdf.height_of_formatted(array, modified_options)
          end
          height
        end

        def text_layout(section, shape)
          y, schema_height = shape.format.attributes.values_at('y', 'height')

          content_height = if shape.style.finalized_styles['overflow'] == 'expand'
            [schema_height, calc_text_block_height(shape)].max
          else
            schema_height
          end

          LayoutInfo.new(shape, content_height, y, section.schema.height - schema_height - y)
        end

        def stack_view_layout(section, shape)
          schema_height = 0
          shape.format.rows.each {|row| schema_height += row.attributes['height']}

          y = shape.format.attributes['y']
          LayoutInfo.new(shape, stack_view_renderer.section_height(shape), y, section.schema.height - schema_height - y)
        end
      end
    end
  end
end
