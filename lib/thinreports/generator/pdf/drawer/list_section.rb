# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    class PDF::Drawer::ListSection < PDF::Drawer::Page
      # @param pdf (see PDF::Drawer::Page#initialize)
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
            @pdf.parse_svg('<svg xmlns:xlink="http://www.w3.org/1999/xlink">' +
                           "#{@format.layout}</svg>", '/svg')
          end
          @stamp_created = true
        end
        pdf_stamp(id)
      end
      
      # @see ThinReports::Generator::PDF::Drawer::Page#draw_tblock_shape      
      def draw_tblock_shape(shape)
        @pdf.translate(*@draw_at) { super }
      end
      
      # @see ThinReports::Generator::PDF::Drawer::Page#draw_iblock_shape      
      def draw_iblock_shape(shape)
        @pdf.translate(*@draw_at) { super }
      end
    end
    
  end
end
