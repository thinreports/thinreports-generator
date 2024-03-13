# frozen_string_literal: true

require_relative 'stack_view_builder'

module Thinreports
  module SectionReport
    module Builder
      class ItemBuilder
        Context = Struct.new(:parent_schema)

        def initialize(item_schema, parent_schema)
          @item_schema = item_schema
          @parent_schema = parent_schema
        end

        def build(item_params)
          params = build_params(item_params)

          build_item(item_schema).tap do |item|
            item.visible(params[:display]) if params.key?(:display)
            item.value(params[:value]) if params.key?(:value)
            item.styles(params[:styles]) if params.key?(:styles)
          end
        end

        private

        attr_reader :item_schema, :parent_schema

        def build_item(schema)
          item_class =
            case schema
            when Schema::TextBlock
              Item::TextBlock
            when Schema::ImageBlock
              Item::ImageBlock
            when Schema::StackView
              Item::StackView
            when Schema::Text
              Item::Text
            when Schema::Basic
              Item::Basic
            end

          item_class.new(schema)
        end

        def build_params(params)
          return {} unless params

          case params
          when Hash
            params
          when Proc
            params.call(Context.new(parent_schema))
          else
            { value: params }
          end
        end
      end
    end
  end
end
