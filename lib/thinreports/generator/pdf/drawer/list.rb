# coding: utf-8

module ThinReports
  module Generator
    
    class Pdf::Drawer::List < Pdf::Drawer::Base
      # @param (see Pdf::Drawer::Base#initialize)
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
      # @return [ThinReports::Generator::Pdf::Drawer::ListSection]
      def drawer(section)
        @sections[section.section_name] ||=
          Pdf::Drawer::ListSection.new(@pdf, section)
      end
    end
    
  end
end
