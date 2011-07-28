# coding: utf-8

module ThinReports
  module Core::Shape
    
    class List::SectionInterface < Base::Interface
      include Core::Shape::Manager::Target
      
      undef_method :list
      internal_delegators :height
      
      # @param [ThinReports::Core::Shape::List::Page] parent
      # @param [ThinReports::Core::Shape::List::SectionFormat] format
      # @param [Symbol] section_name
      def initialize(parent, format, section_name)
        super(parent, format)
        internal.section_name = section_name
        
        initialize_manager(format) do |f|
          Core::Shape::Interface(self, f)
        end
      end
      
      # @param [ThinReports::Core::Shape::List::Page] parent
      # @return [ThinReports::Core::Shape::List::SectionInterface]
      # @private
      def copy(parent)
        new_sec = super
        new_sec.internal.section_name = internal.section_name
        
        manager.shapes.each do |id, shape|
          new_sec.manager.shapes[id] = shape.copy(new_sec)
        end
        new_sec
      end
      
    private
      
      # @param parent (see #initialize)
      # @param format (see #initialize)
      # @return [ThinReports::Core::Shape::List::SectionInternal]
      def init_internal(parent, format)
        List::SectionInternal.new(parent, format)
      end
    end
    
  end
end
