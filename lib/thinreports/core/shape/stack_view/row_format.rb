# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        class RowFormat < Core::Format::Base
          config_reader :id
          config_reader :height
          config_checker true, :display
          config_checker true, auto_stretch: 'auto-stretch'

          attr_reader :items

          def initialize(*)
            super
            @items = []
            @item_with_ids = {}
            initialize_items(attributes['items'])
          end

          def find_item(id)
            @item_with_ids[id.to_sym]
          end

          private

          def initialize_items(item_schemas)
            item_schemas.each do |item_schema|
              item = Core::Shape::Format(item_schema['type']).new(item_schema)
              @items << item
              @item_with_ids[item.id.to_sym] = item unless item.id.empty?
            end
          end
        end
      end
    end
  end
end
