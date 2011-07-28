# coding: utf-8

# @private
module Prawn
  # Patch for issue {https://github.com/sandal/prawn/issues/245 #245}.
  # @private
  class Font::TTF
    def character_width_by_code(code)    
        return 0 unless cmap[code]
        return 0.0 if code == 10
        @char_widths[code] ||= Integer(hmtx.widths[cmap[code]] * scale_factor)
    end    
  end
  
  # @private
  class Document
    # Create around alias.
    alias_method :original_width_of, :width_of
    
    # For Ruby 1.8
    ruby_18 do
      def width_of(string, options={})
        str_length = in_utf8 { string.split(//).size }
        font.compute_width_of(string, options) + character_spacing * (str_length - 1)
      end
    end
    
    # For Ruby 1.9
    ruby_19 do
      def width_of(string, options={})
        font.compute_width_of(string, options) + character_spacing * (string.length - 1)
      end
    end
  end

end
