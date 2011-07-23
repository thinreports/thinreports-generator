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
