# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      module Section
        class Base < Core::Shape::Manager::Format
          config_reader :id, :type
          config_reader :height
          config_checker true, :display
          config_checker true, auto_stretch: 'auto-stretch'

          attr_reader :items

          def initialize(schema_data, items:)
            super(schema_data)
            initialize_items(items)
          end

          def find_item(id)
            @item_with_ids[id.to_sym]
          end

          private

          def initialize_items(items)
            @items = items
            @item_with_ids = items.each_with_object({}) do |item, item_with_ids|
              next if item.id.empty?
              item_with_ids[item.id.to_sym] = item
            end
          end
        end

        class Header < Base
          config_checker true, every_page: 'every-page'
        end

        class Footer < Base
        end

        class Detail < Base
        end
      end
    end
  end
end
