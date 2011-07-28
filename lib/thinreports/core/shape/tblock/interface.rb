# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Tblock::Interface < Basic::Interface
      internal_delegators :format_enabled?
      
      # @param [Boolean] enabled
      # @return [self]
      def format_enabled(enabled)
        internal.format_enabled(enabled)
        self
      end
      
      # @overload value(val)
      #   Set a val
      #   @param [Object] val
      #   @return [self]
      # @overload value
      #   Return the value
      #   @return [Object]
      def value(*args)
        case args.size
        when 0
          internal.read_value
        when 1
          internal.write_value(args.first)
          self
        else
          raise ArgumentError, '#value can take 0 or 1 argument.'
        end
      end
      
      # @param [Object] val
      # @param [Hash<Symbol, Object>] style_settings
      # @return [self]
      def set(val, style_settings = {})
        value(val)
        styles(style_settings) #=> self
      end
    
    private
      
      # @see ThinReports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        Tblock::Internal.new(parent, format)
      end
    end
    
  end
end