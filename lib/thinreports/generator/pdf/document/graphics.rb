# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module Graphics
        BASE_LINE_WIDTH = 0.9

        private

        # Change the default graphic states defined by Prawn.
        def setup_custom_graphic_states
          pdf.line_width(BASE_LINE_WIDTH)
        end

        # @param [Numeric] width
        def line_width(width)
          pdf.line_width(width * BASE_LINE_WIDTH)
        end

        # Delegate to Prawn::Document#save_graphic_state
        # @see Prawn::Document#save_graphics_state
        def save_graphics_state
          pdf.save_graphics_state
        end

        # Delegate to Prawn::Document#restore_graphic_state
        # @see Prawn::Document#restore_graphics_state
        def restore_graphics_state
          pdf.restore_graphics_state
        end
      end
    end
  end
end

require_relative 'graphics/attributes'
require_relative 'graphics/basic'
require_relative 'graphics/image'
require_relative 'graphics/text'
