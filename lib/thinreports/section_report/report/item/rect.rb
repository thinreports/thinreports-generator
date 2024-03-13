# frozen_string_literal: true

require 'style'

module Thinreports
  module SectionReport
    module Report
      module Item
        class Rect < Base
          def_delegators :schema,
                         :x, :y, :width, :height, :border_radius,
                         :affect_bottom_margin?

          def style
            @style ||= Style::Rect.new(schema.style)
          end

          def render(pdf, height_to_expand: nil)
            Renderer::RectRenderer.new(pdf, self).render
          end
        end
      end
    end
  end
end
