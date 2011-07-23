# coding: utf-8

module ThinReports
  module Core::Shape::Tblock
    
    # @private
    class Formatter::Padding < Formatter::Basic
      
    private
    
    ruby_18 do
      def apply_format_to(value)
        strs    = in_utf8 { value.to_s.split(//) }
        pad_len = format.format_padding_length
        
        if pad_len > strs.size
          pad_strs = format.format_padding_char * (pad_len - strs.size)
          if format.format_padding_rdir?
            strs.to_s + pad_strs
          else
            pad_strs + strs.to_s
          end
        else
          value.to_s
        end
      end
    end
    
    ruby_19 do
      def apply_format_to(value)
        value.to_s.send(format.format_padding_rdir? ? :ljust : :rjust,
                        format.format_padding_length,
                        format.format_padding_char)
      end
    end
    
      def applicable?(value)
        !format.format_padding_char.blank? && format.format_padding_length > 0
      end
    end
    
  end
end