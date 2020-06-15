# frozen_string_literal: true

require_relative 'stack_view_data'

module Thinreports
  module SectionReport
    module Builder
      class StackViewBuilder
        def initialize(item)
          @item = item
        end

        def update(params)
          rows_params = params[:rows] || {}
          rows_schema = item.internal.format.rows

          schema_row_ids = rows_schema.map {|row_schema| row_schema.id.to_sym}.to_set
          rows_params.each_key do |row_id|
            raise Thinreports::Errors::UnknownSectionId.new(:row, row_id) unless schema_row_ids.include? row_id
          end

          rows = []
          rows_schema.each do |row_schema|
            row_params = rows_params[row_schema.id.to_sym] || {}
            next unless row_enabled?(row_schema, row_params)

            items = build_row_items(
              row_schema,
              row_params[:items] || {}
            )

            rows << StackViewData::Row.new(row_schema, items, row_params[:min_height])
          end
          item.internal.rows = rows
        end

        private

        attr_reader :item

        def build_row_items(row_schema, items_params)
          row_schema.items.each_with_object([]) do |item_schema, items|
            item = ItemBuilder.new(item_schema, row_schema).build(items_params[item_schema.id&.to_sym])
            items << item if item.visible?
          end
        end

        def row_enabled?(row_schema, row_params)
          if row_params.key?(:display)
            row_params[:display]
          else
            row_schema.display?
          end
        end
      end
    end
  end
end
