# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Tblock::Internal < Basic::Internal
      format_delegators :multiple?, :box
      
      def initialize(*args)
        super(*args)
        
        @reference = nil
        @formatter = nil
      end
      
      def read_value
        if format.has_reference?
          @reference ||= parent.item(format.ref_id)
          @reference.value
        else
          states.key?(:value) ? states[:value] : format.value
        end
      end
      alias_method :value, :read_value
      
      def write_value(val)
        if format.has_reference?
          warn 'The set value is not reflected, ' +
               "Because '#{format.id}' refers to '#{format.ref_id}'."
        else
          states[:value] = val
        end
      end
      
      def real_value
        if format_enabled?
          formatter.apply(read_value)
        else
          read_value
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
          format.has_format?
        end
      end
      
      def type_of?(type_name)
        type_name == :tblock
      end
      
    private
      
      def formatter
        @formatter ||= Tblock::Formatter.setup(format)
      end
    end
    
  end
end