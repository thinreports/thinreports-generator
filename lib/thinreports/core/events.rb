# coding: utf-8

module ThinReports
  module Core
    
    class Events
      Event = ::Struct.new(:type, :target)
      
      # @return [Hash<Symbol, ThinReports::Core::Events::Event>]
      # @private
      attr_accessor :events
      
      # @param [Symbol] types
      def initialize(*types)
        @events = {}
        @types  = types
      end
      
      # @param [Symbol] type
      # @yield [e]
      # @yieldparam [ThinReports::Core::Events::Event] e
      def listen(type, &block)
        verify_event_type(type)
        
        if block_given?
          events[type] = block
        else
          raise ArgumentError, '#listen requires a block'
        end
      end
      alias_method :on, :listen
      
      # @param [Symbol] type
      def unlisten(type)
        events.delete(type)
      end
      alias_method :un, :unlisten
      
      # @private
      def dispatch(e)
        unless e.type
          raise ArgumentError, 'Event#type attribute is required'
        end
        verify_event_type(e.type)

        if event = events[e.type]
          event.call(e)
        end
      end
      
      # @private
      def copy
        new_events = self.dup
        new_events.events = events.simple_deep_copy
        new_events
      end
      
    private
      
      # @param [Symbol] type
      def verify_event_type(type)
        return if @types.empty?
        
        unless @types.include?(type)
          raise ThinReports::Errors::UnknownEventType
        end
      end
    end

  end
end
