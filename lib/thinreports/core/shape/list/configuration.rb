# coding: utf-8

module Thinreports
  module Core::Shape

    class List::Configuration
      # @return [Thinreports::Core::Shape::List::Store]
      # @deprecated
      #   `List#store` will be removed in the next major version.
      #   Please create a manually list using `List#overflow?`. See below for further details.
      #   https://github.com/thinreports/thinreports-generator/blob/master/examples/list_manual_generation/list_manual_generation.rb
      attr_reader :store

      # @param [Thinreports::Core::Shape::List::Events, nil] events (nil)
      # @param [Thinreports::Core::Shape::List::Store, nil] store (nil)
      def initialize(events = nil, store = nil)
        @events = events || List::Events.new
        @store  = store
      end

      # @return [Thinreports::Core::Shape::List::Events]
      # @deprecated
      #   `List#events` will be removed in the next major version.
      #   Please create a manually list using `List#overflow?`. See below for further details.
      #   https://github.com/thinreports/thinreports-generator/blob/master/examples/list_manual_generation/list_manual_generation.rb
      def events
        warn '[DEPRECATION] `List#events` will be removed in the next major version.' +
             'Please create a manually list using `List#overflow?`. See below for further details.'
        @events
      end

      # @private
      def internal_events
        @events
      end

      # @param [Hash] stores name: default value
      def use_stores(stores)
        @store = List::Store.init(stores)
      end

      # @return [Thinreports::Core::Shape::List::Configuration]
      # @private
      def copy
        self.class.new(@events.copy, @store && @store.copy)
      end

      # @return [String]
      def type
        List::TYPE_NAME
      end
    end

  end
end
