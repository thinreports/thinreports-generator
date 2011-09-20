# coding: utf-8

module ThinReports
  module Core::Shape::TextBlock
    
    # @private
    class Formatter::Datetime < Formatter::Basic
      
    private
      
      def apply_format_to(value)
        value.strftime(format.format_datetime_format)
      end
      
      def applicable?(value)
        !format.format_datetime_format.blank? && value.respond_to?(:strftime)
      end
    end
    
  end
end