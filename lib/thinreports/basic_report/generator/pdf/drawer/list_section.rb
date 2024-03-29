# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Generator
      class PDF
        module Drawer
          class ListSection < Page
            # @param pdf (see PDF::Drawer::Page#initialize)
            # @param section [Thinreports::BasicReport::Core::Shape::List::SectionInternal] section
            def initialize(pdf, section)
              super(pdf, section.format)
              @section = section
              @stamp_created = false
            end

            # @param [Thinreports::BasicReport::Core::Shape::List::SectionInternal] section
            # @param [Array<Numeric>] at
            def draw(section, at)
              @draw_at = at
              draw_section
              super(section)
            end

            private

            def draw_section
              id = @format.identifier.to_s

              unless @stamp_created
                @pdf.create_stamp(id) { @pdf.draw_template_items(@format.attributes['items']) }
                @stamp_created = true
              end
              pdf_stamp(id)
            end

            # @see Thinreports::BasicReport::Generator::PDF::Drawer::Page#draw_tblock_shape
            def draw_tblock_shape(shape)
              @pdf.translate(*@draw_at) { super }
            end

            # @see Thinreports::BasicReport::Generator::PDF::Drawer::Page#draw_iblock_shape
            def draw_iblock_shape(shape)
              @pdf.translate(*@draw_at) { super }
            end
          end
        end
      end
    end
  end
end
