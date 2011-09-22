# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    class PDF::Drawer::List < PDF::Drawer::Base
      # @param (see PDF::Drawer::Base#initialize)
      def initialize(pdf, format)
        super
        @sections = {}
      end
      
      # @param [ThinReports::Core::Shape::List::PageState] list
      def draw(list)
        draw_section(list.header) if list.header
        list.rows.each do |row|
          draw_section(row)
        end
      end
      
    private  
      
      # @param [ThinReports::Core::Shape::List::SectionInterface] section
      def draw_section(section)
        internal = section.internal
        drawer(internal).draw(section.manager, internal.relative_position)
      end
      
      # @param [ThinReports::Core::Shape::List::SectionInternal] section
      # @return [ThinReports::Generator::PDF::Drawer::ListSection]
      def drawer(section)
        @sections[section.section_name] ||=
          PDF::Drawer::ListSection.new(@pdf, section)
      end
    end
    
  end
end
