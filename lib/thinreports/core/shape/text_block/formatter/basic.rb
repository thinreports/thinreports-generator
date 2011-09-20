# coding: utf-8

module ThinReports
  module Core::Shape::TextBlock
    
    # @private
    class Formatter::Basic
      attr_reader :format
      
      def initialize(format)
        @format = format
      end
      
      def apply(value)
        if applicable?(value)
          value = apply_format_to(value)
        end
        
        unless format.format_base.blank?
          format.format_base.gsub(/\{value\}/, value.to_s)
        else
          value
        end
      end
    
    private
      
      def apply_format_to(value)
        value
      end
      
      def applicable?(value)
        true
      end
    end
    
  end
end