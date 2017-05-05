# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Style
        class Graphic < Style::Basic
          style_accessible :border_color, :border_width, :fill_color, :border

          # @method border_color
          #   @return [String]
          # @method border_color=(color)
          #   @param [String] color
          style_accessor :border_color, 'border-color'

          # @method border_width
          #   @return [Number]
          style_accessor :border_width, 'border-width'

          # @method fill_color
          #   @return [String]
          # @method fill_color=(color)
          #   @param [String] color
          style_accessor :fill_color, 'fill-color'

          # @return [Array<String, Number>]
          def border
            [border_width, border_color]
          end

          # @param [Array<String, Number>] width_and_color
          def border=(width_and_color)
            w, c = width_and_color
            self.border_width = w
            self.border_color = c
          end
        end
      end
    end
  end
end
