module Thinreports
  module SectionReport
    module Builder
      class ItemBuilder
        def initialize(item_schema)
          @item = Core::Shape::Interface(nil, item_schema)
        end

        def build(item_params)
          return item unless item_params

          params = normalize_params(item_params)

          # TODO:
          # * PageNumber#format
          # * TextBlock#format_enabled

          item.visible(params[:display]) if params.key?(:display)
          item.value(params[:value]) if params.key?(:value)
          item.styles(params[:styles]) if params.key?(:styles)

          ## TODO: renderするときにrows を取り出せるように,StackView の Interfaceを拡張する
          if item.internal.format.attributes['type'] == Core::Shape::StackView::TYPE_NAME
            row_schemas = item.internal.format.rows

            schema_row_ids = row_schemas.map { |row_schema| row_schema.attributes['id'].to_sym }.to_set
            item_params.each_key do |row_id|
              next if row_id == :display # XXX
              raise Thinreports::Errors::UnknownSectionId.new(:row, row_id) unless schema_row_ids.include? row_id
            end

            rows = []
            row_schemas.each do |row_schema|
              row_params = item_params[row_schema.attributes['id'].to_sym] || {}
              next unless row_enabled?(row_schema, row_params)
              items = build_row_items(row_schema, row_params)
              rows << ReportData::Row.new(row_schema, items, nil)
            end
            item.internal.rows = rows
          end

          item
        end

        private

        attr_reader :item

        def normalize_params(params)
          params.is_a?(Hash) ? params : { value: params }
        end

        def build_row_items(row_schema, row_params)
          items_params = {}
          unless row_params.nil?
            items_params = row_params[:items] || {}
          end

          schema_ids = row_schema.shapes.map { |shape| shape.attributes['id']&.to_sym }.to_set.subtract([nil, :""])
          items_params.each_key do |key|
            raise Thinreports::Errors::UnknownItemId.new(key, 'Row') unless schema_ids.include? key
          end

          row_schema.shapes.each_with_object([]) do |shape, items|
            item = ItemBuilder.new(shape).build(items_params[shape.attributes['id']&.to_sym])
            items << item if item.visible?
          end
        end

        def row_enabled?(row_schema, row_params)
          return false if row_schema.display == false
          return false if row_params.key?(:display) && !row_params[:display]
          true
        end
      end
    end
  end
end
