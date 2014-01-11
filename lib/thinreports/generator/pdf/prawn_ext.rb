# coding: utf-8

# @private
module Prawn
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

  # Patch: https://github.com/prawnpdf/prawn/commit/34039d13b7886692debca11e85b9a572a20d57ee
  module Core 
    class Reference
      def <<(data)
        (@stream ||= "") << data
        @data[:Length] = @stream.length
        @stream
      end
 
      def compress_stream
        @stream = Zlib::Deflate.deflate(@stream)
        @data[:Filter] = :FlateDecode
        @data[:Length] = @stream.length
        @compressed = true
      end
    end
  end
end
