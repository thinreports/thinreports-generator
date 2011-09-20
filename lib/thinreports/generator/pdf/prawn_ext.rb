# coding: utf-8

# @private
module Prawn
  # @private
  class Document
    # Create around alias.
    alias_method :original_width_of, :width_of
    
    def width_of(string, options={})
      font.compute_width_of(string, options) +
        (character_spacing * (font.character_count(string) - 1))
    end
    
  private
    # Create around alias.
    alias_method :original_calc_image_dimensions, :calc_image_dimensions
    
    def calc_image_dimensions(info, options)
      if options[:auto_fit]
        w, h = info.width, info.height
        sw, sh = options.delete(:auto_fit)
        
        if w > sw || h > sh
          options[:fit] = [sw, sh]
        end
      end
      original_calc_image_dimensions(info, options)
    end
  end
end
