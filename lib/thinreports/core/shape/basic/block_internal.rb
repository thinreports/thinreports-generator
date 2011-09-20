# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Basic::BlockInternal < Basic::Internal
      format_delegators :box
      
      def read_value
        states.key?(:value) ? states[:value] : format.value
      end
      alias_method :value, :read_value
      
      def write_value(val)
        states[:value] = val
      end
      
      def type_of?(type_name)
        type_name == :block
      end
    end
    
  end
end