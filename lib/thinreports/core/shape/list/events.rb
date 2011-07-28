# coding: utf-8

module ThinReports
  module Core::Shape
    
    class List::Events < Core::Events
      def initialize
        super(:page_footer_insert,
              :footer_insert)
      end
      
      class SectionEvent < Event
        # @return [ThinReports::Core::Shape::List::Store]
        attr_reader :store
        
        # @param type (see ThinReports::Core::Events::Event#initialize)
        # @param target (see ThinReports::Core::Events::Event#initialize)
        # @param [ThinReports::Core::Shape::List::Store] store
        def initialize(type, target, store)
          super(type, target)
          @store = store
        end
        
        # @return [ThinReports::Core::Shape::List::SectionInterface]
        alias_method :section, :target
      end
    end
    
  end
end
