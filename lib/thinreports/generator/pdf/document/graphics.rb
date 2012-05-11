# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module PDF::Graphics
      
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

require 'thinreports/generator/pdf/document/graphics/attributes'
require 'thinreports/generator/pdf/document/graphics/basic'
require 'thinreports/generator/pdf/document/graphics/image'
require 'thinreports/generator/pdf/document/graphics/text'
