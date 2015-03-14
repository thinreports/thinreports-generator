# coding: utf-8

module Thinreports
  module Core

    class Events
      include Utils

      Event = ::Struct.new(:type, :target)

      # @return [Hash<Symbol, Thinreports::Core::Events::Event>]
      # @private
      attr_accessor :events

      # @param [Symbol] types
      def initialize(*types)
        @events = {}
        @types  = types
      end

      # @param [Symbol] type
      # @yield [e]
      # @yieldparam [Thinreports::Core::Events::Event] e
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
        new_events.events = deep_copy(events)
        new_events
      end

    private

      # @param [Symbol] type
      def verify_event_type(type)
        return if @types.empty?

        unless @types.include?(type)
          raise Thinreports::Errors::UnknownEventType
        end
      end
    end

  end
end
