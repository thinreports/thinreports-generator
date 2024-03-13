# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      module ItemContainer
        attr_reader :items

        def initialize_items
          @items = schema['items'].each_with_object([]) do |schema, m|
            item_schema = initialize_item_schema(schema)

            next if item_schema.id.empty?

            m << item_schema
          end
        end

        def initialize_item_schema(schema)
          schema_class =
            case schema['type']
            when 'text-block'
              Schema::TextBlock
            when 'image-block'
              Schema::ImageBlock
            when 'stack-view'
              Schema::StackView
            when 'text'
              Schema::Text
            when 'rect'
              Schema::Rect
            when 'line', 'ellipse', 'image'
              Schema::Basic
            end

          schema_class.new(item_schema)
        end
      end
    end
  end
end
