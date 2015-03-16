# coding: utf-8

module Thinreports
  module Core::Shape
    
    class List::Events < Core::Events
      def initialize
        super(:page_footer_insert,
              :footer_insert,
              :page_finalize)
      end
      
      class PageEvent < Event
        # @return [Thinreports::Report::Page]
        attr_reader :page
        
        # @param type (see Thinreports::Core::Events::Event#initialize)
        # @param [Thinreports::Core::Shape::List::Page] target
        # @param [Thinreports::Report::Page] page
        def initialize(type, target, page)
          super(type, target)
          @page = page
        end
        
        # @return [Thinreports::Core::Shape::List::Page]
        alias_method :list, :target
      end
      
      class SectionEvent < Event
        # @return [Thinreports::Core::Shape::List::Store]
        attr_reader :store
        
        # @param type (see Thinreports::Core::Events::Event#initialize)
        # @param [Thinreports::Core::Shape::List::SectionInterface] target
        # @param [Thinreports::Core::Shape::List::Store] store
        def initialize(type, target, store)
          super(type, target)
          @store = store
        end
        
        # @return [Thinreports::Core::Shape::List::SectionInterface]
        alias_method :section, :target
      end
    end
    
  end
end
