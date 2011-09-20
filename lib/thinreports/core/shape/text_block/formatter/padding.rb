# coding: utf-8

module ThinReports
  module Core::Shape::TextBlock
    
    # @private
    class Formatter::Padding < Formatter::Basic
      
    private
    
    ruby_18 do
      def apply_format_to(value)
        value = value.to_s
        
        char_length = value.unpack('U*').length
        pad_length  = format.format_padding_length
        
        if pad_length > char_length
          pad_strs = format.format_padding_char * (pad_length - char_length)
          if format.format_padding_rdir?
            value + pad_strs
          else
            pad_strs + value
          end
        else
          value
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