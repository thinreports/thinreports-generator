# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Generator
      class PDF
        module Drawer
          class List < Base
            # @param (see PDF::Drawer::Base#initialize)
            def initialize(pdf, format)
              super
              @sections = {}
            end

            # @param [Thinreports::BasicReport::Core::Shape::List::PageState] list_page
            def draw(list_page)
              draw_section(list_page.header) if list_page.header
              list_page.rows.each do |row|
                draw_section(row)
              end

              # Returns Thinreports::BasicReport::Report::Page object
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
            # @param [Thinreports::BasicReport::Core::Shape::Base::Format] shape
            # @return [Boolean]
            def list_pageno?(list_id, shape)
              shape.type == Thinreports::BasicReport::Core::Shape::PageNumber::TYPE_NAME &&
                shape.target == list_id
            end

            # @param [Thinreports::BasicReport::Core::Shape::List::SectionInterface] section
            def draw_section(section)
              internal = section.internal

              base_top = @format.section_base_position_top(internal.section_name)
              position = [internal.relative_left, base_top + internal.relative_top]

              drawer(internal).draw(section, position)
            end

            # @param [Thinreports::BasicReport::Core::Shape::List::SectionInternal] section
            # @return [Thinreports::BasicReport::Generator::PDF::Drawer::ListSection]
            def drawer(section)
              @sections[section.section_name] ||= ListSection.new(@pdf, section)
            end
          end
        end
      end
    end
  end
end
