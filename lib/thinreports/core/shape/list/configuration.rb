# coding: utf-8

module ThinReports
  module Core::Shape
    
    class List::Configuration
      # @return [ThinReports::Core::Shape::List::Events]
      attr_reader :events
      
      # @return [ThinReports::Core::Shape::List::Store]
      attr_reader :store
            
      # @param [ThinReports::Core::Shape::List::Events, nil] events (nil)
      # @param [ThinReports::Core::Shape::List::Store, nil] store (nil)
      def initialize(events = nil, store = nil)
        @events = events || List::Events.new
        @store  = store
      end
      
      # @param [Hash] stores :name => default value
      def use_stores(stores)
        @store = List::Store.init(stores)
      end
      
      # @return [ThinReports::Core::Shape::List::Configuration]
      # @private
      def copy
        self.class.new(@events.copy, @store && @store.copy)
      end
    end
    
  end
end