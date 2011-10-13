# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Basic::BlockInternal < Basic::Internal
      format_delegators :box
      
      def style
        @style ||= Style::Basic.new(format)
      end
      
      def read_value
        states.key?(:value) ? states[:value] : format.value.dup
      end
      alias_method :value, :read_value
      
      def write_value(val)
        states[:value] = val
      end
      
      def real_value
        read_value
      end
      
      def type_of?(type_name)
        type_name == :block
      end
    end
    
  end
end