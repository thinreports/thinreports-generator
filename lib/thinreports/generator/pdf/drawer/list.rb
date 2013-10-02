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
      def draw(list_page)
        draw_section(list_page.header) if list_page.header
        list_page.rows.each do |row|
          draw_section(row)
        end

        # Returns ThinReports::Core::Page object
        manager = list_page.parent.manager

        list_id = list_page.id.to_s
        manager.format.shapes.each do |id, shape|
          next unless list_pageno?(list_id, shape)

          shape = manager.final_shape(id)
          @pdf.draw_shape_pageno(shape.internal, 
                                 list_page.no, list_page.manager.page_count)
        end
      end

    private

      # @param [String] list_id
      # @param [ThinReports::Core::Shape::Base::Format] shape
      # @return [Boolean]
      def list_pageno?(list_id, shape)
        shape.type == ThinReports::Core::Shape::PageNumber::TYPE_NAME &&
        shape.target == list_id
      end

      # @param [ThinReports::Core::Shape::List::SectionInterface] section
      def draw_section(section)
        internal = section.internal
        drawer(internal).draw(section, internal.relative_position)
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
