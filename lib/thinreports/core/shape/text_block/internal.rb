# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class TextBlock::Internal < Basic::BlockInternal
      format_delegators :multiple?
      
      def initialize(*args)
        super(*args)
        
        @reference = nil
        @formatter = nil
        
        @style = Style::Text.new(format)
        @style.accessible_styles.delete(:valign) unless multiple?
      end
      
      def style
        @style
      end
      
      def read_value
        if format.has_reference?
          @reference ||= parent.item(format.ref_id)
          @reference.value
        else
          super
        end
      end
      
      def write_value(val)
        if format.has_reference?
          warn 'The set value was not saved, ' +
               "Because '#{format.id}' refers to '#{format.ref_id}'."
        else
          super
        end
      end
      
      def real_value
        if format_enabled?
          formatter.apply(read_value)
        else
          super
        end
      end
      
      def format_enabled(enabled)
        states[:format_enabled] = enabled
      end
      
      def format_enabled?
        return false if multiple?
        
        if states.key?(:format_enabled)
          states[:format_enabled]
        else
          !format.format_base.blank? || format.has_format?
        end
      end
      
      def type_of?(type_name)
        type_name == :tblock || super
      end
      
    private
      
      def formatter
        @formatter ||= TextBlock::Formatter.setup(format)
      end
    end
    
  end
end