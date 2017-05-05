# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class SectionFormat < Shape::Manager::Format
          config_reader :height
          config_reader relative_left: %w[translate x],
                        relative_top: %w[translate y]
          config_reader :style

          # For compatible 0.8.x format API
          config_checker true, display: %w[enabled]

          def initialize(*)
            super
            initialize_items(attributes['items'])
          end

          private

          def initialize_items(item_schemas)
            item_schemas.each do |item_schema|
              id, type = item_schema.values_at 'id', 'type'
              next if id.empty?

              shapes[id.to_sym] = Core::Shape::Format(type).new(item_schema)
            end
          end
        end
      end
    end
  end
end
