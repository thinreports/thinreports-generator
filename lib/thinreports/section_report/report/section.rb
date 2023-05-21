# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Report
      class Section
        Dimentions = Struct.new(:bottom_margin, :content_bottom)

        attr_reader :schema, :items, :min_height

        def initialize(schema, items, min_height: nil)
          @schema = schema
          @items = items
          @min_height = min_height || 0
        end

        def render(pdf)
          Renderer::SectionRenderer.new(pdf, self).render
        end

        def height
          return [min_height, schema.height].max if schema.auto_stretch? || items.empty?

          # item_layouts = section.items.map { |item| item_layout(section, item.internal) }.compact

          max_content_bottom = item_layouts.each_with_object([]) do |l, bottoms|
            bottoms << l.top_margin + l.content_height if l.shape.format.affect_bottom_margin?
          end.max.to_f

          [section.min_height || 0, max_content_bottom + min_bottom_margin].max
        end

        def bottom_margin
        end

        def content_bottom
        end
      end
    end
  end
end
