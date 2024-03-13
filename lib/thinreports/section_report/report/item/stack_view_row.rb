# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Report
      module Item
        class StackViewRow
          def initialize(schema, items, min_height: nil)
            @schema = schema
            @items = items
            @min_height = min_height
          end

          def render
            Renderer::StackViewRowRenderer.new(self).render
          end
        end
      end
    end
  end
end
