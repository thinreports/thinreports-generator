# frozen_string_literal: true

require 'forwardable'
require 'style'

module Thinreports
  module SectionReport
    module Report
      module Item
        class TextBlock < Base
          def style
            @style ||= Style::TextBlock.new(schema.style)
          end

          def render
            Renderer::TextBlockRenderer.new(self).render
          end
        end
      end
    end
  end
end
