module Thinreports
  module SectionReport
    module Schema
      module Section
        class Base < Core::Shape::Manager::Format
          config_reader :id, :type
          config_reader :top, :height
          config_checker true, :display

          attr_reader :items, :item_ids

          def initialize(schema_data, items:)
            super(schema_data)
            initialize_items(items)
          end

          private

          def initialize_items(items)
            @items = items
            @item_ids = items.reject { |item| item.id.empty? }.map { |item| item.id.to_sym }
          end
        end

        class Header < Base
          config_checker true, every_page: 'every-page'
        end

        class Footer < Base
          config_checker true, fixed_bottom: 'fixed-bottom'
        end

        class Detail < Base
          config_checker true, auto_expand: 'auto-expand'
        end
      end
    end
  end
end
