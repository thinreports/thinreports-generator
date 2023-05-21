# frozen_string_literal: true

require_relative 'stack_view_data'

module Thinreports
  module SectionReport
    module Builder
      class StackViewItemBuilder
        def initialize(item_schema, parent_schema)
          @item_schema = item_schema
          @parent_schema = parent_schema
        end

        def build(item_params)
          rows = build_rows(item_params[:rows] || {})

          item = Report::Item::StackView.new(item_schema, rows)
          item.visible(item_params[:display]) if item_params.key?(:display)

          item
        end

        private

        attr_reader :item_schema

        def build_rows(rows_params)
          item_schema.rows.each_with_object([]) do |row_schema, m|
            row_params = rows_params[row_schema.id.to_sym] || {}

            next unless row_enabled?(row_schema, row_params)

            items = build_row_items(
              row_schema,
              row_params[:items] || {}
            )

            m << Report::Item::StackViewRow.new(row_schema, items, **row_params.slice(:min_height))
          end
        end

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
