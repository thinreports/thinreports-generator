# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        class RowFormat < Core::Format::Base
          config_reader :height
          config_reader :display
          config_checker true, auto_expand: 'auto-expand'
          config_checker true, auto_shrink: 'auto-shrink'

          attr_reader :shapes
          attr_reader :shapes_by_id

          def initialize(*)
            super
            @shapes = []
            @shapes_by_id = {}
            initialize_items(attributes['items'])
          end

          private

          def initialize_items(item_schemas)
            item_schemas.each do |item_schema|
              id, type = item_schema.values_at 'id', 'type'

              shape = Core::Shape::Format(type).new(item_schema)
              shapes << shape
              @shapes_by_id[id.to_sym] = shape if id
            end
          end
        end
      end
    end
  end
end
