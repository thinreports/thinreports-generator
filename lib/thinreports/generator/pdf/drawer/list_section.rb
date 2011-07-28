# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    class Pdf::Drawer::ListSection < Pdf::Drawer::Page
      # @param pdf (see Pdf::Drawer::Page#initialize)
      # @param section [ThinReports::Core::Shape::List::SectionInternal] section
      def initialize(pdf, section)
        super(pdf, section.format)
        @section       = section
        @stamp_created = false
      end
      
      # @param [ThinReports::Core::Shape::Manager::Internal] manager
      # @param [Array<Numeric>] at
      def draw(manager, at)
        @draw_at = at
        draw_section
        super(manager)
      end
      
    private
      
      def draw_section
        id = @format.identifier.to_s
        
        unless @stamp_created
          @pdf.create_stamp(id) do
            @pdf.parse_svg("<g>#{@format.layout}</g>", '/g')
          end
          @stamp_created = true
        end
        pdf_stamp(id)
      end
      
      # @see ThinReports::Generator::Pdf::Drawer::Page#draw_tblock_shape      
      def draw_tblock_shape(shape)
        @pdf.translate(*@draw_at) { super }
      end
    end
    
  end
end
