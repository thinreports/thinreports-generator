# coding: utf-8

require 'bigdecimal'

module ThinReports
  module Core::Shape::TextBlock
    
    # @private
    class Formatter::Number < Formatter::Basic
      
    private
      
      def apply_format_to(value)
        precision = format.format_number_precision
        delimiter = format.format_number_delimiter
        
        if_applicable value do |val|
          unless precision.blank?
            val = number_with_precision(val, precision)
          end
          unless delimiter.blank?
            val = number_with_delimiter(val, delimiter)
          end
          val
        end
      end

      def if_applicable(value, &block)
        val = case value
          when Numeric then value
          when String
            (Integer(value) rescue nil) || (Float(value) rescue nil)
          else nil
        end
        val.nil? ? value : block.call(val)
      end
      
      def number_with_delimiter(value, delimiter = ',')
        value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/){ "#{$1}#{delimiter}" }
      end
      
      def number_with_precision(value, precision = 3)
        value = BigDecimal(value.to_s).round(precision)
        sprintf("%.#{precision}f", value)
      end
    end
    
  end
end