# frozen_string_literal: true

require 'forwardable'
require 'style'

module Thinreports
  module SectionReport
    module Report
      module Item
        class StackView < Base
          attr_reader :rows

          def_delegators :schema, :height

          def initialize(schema, rows)
            super(schema)
            @rows = rows
          end

          def render(pdf)
            Renderer::StackViewRenderer.new(pdf, self).render
          end
        end
      end
    end
  end
end
