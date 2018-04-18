module Thinreports
  module SectionReport
    module Renderer
      module ContentHeight
        def content_height(section)
          h_array = [section.min_height || 0]
          h_array << section.schema.height unless section.schema.auto_shrink?

          return h_array.max unless section.schema.auto_expand? && section.items

          text_items = section.items.select do |s|
            s.internal.type_of?(Core::Shape::TextBlock::TYPE_NAME) && s.internal.style.finalized_styles['overflow'] == 'expand'
          end

          stack_view_items = section.items.select do |s|
            s.internal.type_of?(Core::Shape::StackView::TYPE_NAME)
          end

          layouts = text_items.map {|t| text_layout(section, t)} + stack_view_items.map {|s| stack_view_layout(section, s)}
          unless layouts.empty?
            max_content_bottom = layouts.map {|l| l[:top_margin] + l[:content_height]}.max
            min_bottom_margin = layouts.map {|l| l[:bottom_margin]}.min
            h_array << max_content_bottom + min_bottom_margin
          end

          h_array.max
        end

        def text_layout(section, item)
          content_height = 0
          pdf.draw_shape_tblock(item.internal) {|array, options|
            page_height = pdf.pdf.bounds.height
            modified_options = options.merge(at: [0, page_height], height: page_height)
            content_height = pdf.pdf.height_of_formatted(array, modified_options)
          }

          {
            content_height: content_height,
            top_margin: item.internal.format.attributes['y'],
            bottom_margin:
              (section.schema.height - item.internal.format.attributes['height'] - item.internal.format.attributes['y'])
          }
        end

        def stack_view_layout(section, stack_view)
          schema_height = 0
          stack_view.internal.format.rows.each {|row| schema_height += row.attributes['height']}
          {
            content_height: stack_view_renderer.content_height(stack_view.internal),
            top_margin: stack_view.internal.format.attributes['y'],
            bottom_margin: (section.schema.height - schema_height - stack_view.internal.format.attributes['y'])
          }
        end
      end
    end
  end
end
