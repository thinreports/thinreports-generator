# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    class PDF::Drawer::Page < PDF::Drawer::Base
      # @param (see PDF::Drawer::Base#initialize)
      def initialize(pdf, format)
        super
        @lists = {}
      end
      
      # @param [ThinReports::Core::Shape::Manager::Internal] manager
      def draw(manager)
        manager.format.shapes.each_key do |id|
          if shape = manager.final_shape(id)
            draw_shape(shape.internal)
          end
        end
      end
      
    private
      
      # @param [ThinReports::Core::Shape::Base::Internal] shape
      def draw_shape(shape)
        case
        when shape.type_of?(:tblock)
          draw_tblock_shape(shape)
        when shape.type_of?(:list)
          draw_list_shape(shape)
        when shape.type_of?(:iblock)
          draw_iblock_shape(shape)
        else
          id = shape_stamp_id(shape)
          unless @stamps.include?(id)
            create_basic_shape_stamp(shape)
            @stamps << id
          end
          pdf_stamp(shape)
        end
      end
      
      # @see #draw_shape
      def draw_list_shape(shape)
        drawer = @lists[shape.id] ||= PDF::Drawer::List.new(@pdf, shape.format)
        drawer.draw(shape)
      end
      
      # @see #draw_shape
      def draw_tblock_shape(shape)
        @pdf.draw_shape_tblock(shape)
      end
      
      # @see #draw_shape
      def draw_iblock_shape(shape)
        @pdf.draw_shape_iblock(shape)
      end
      
      # @param [ThinReports::Core::Shape::Base::Internal] shape
      def create_basic_shape_stamp(shape)
        case
        when shape.type_of?(:text)    then create_text_stamp(shape)
        when shape.type_of?(:image)   then create_image_stamp(shape)
        when shape.type_of?(:ellipse) then create_ellipse_stamp(shape)
        when shape.type_of?(:rect)    then create_rect_stamp(shape)
        when shape.type_of?(:line)    then create_line_stamp(shape)
        end
      end
      
      # @see #create_basic_shape_stamp
      def create_image_stamp(shape)
        create_pdf_stamp(shape) do
          @pdf.draw_shape_image(shape)
        end
      end
      
      # @see #create_basic_shape_stamp
      def create_rect_stamp(shape)
        create_pdf_stamp(shape) do
          @pdf.draw_shape_rect(shape)
        end
      end
      
      # @see #create_basic_shape_stamp
      def create_ellipse_stamp(shape)
        create_pdf_stamp(shape) do
          @pdf.draw_shape_ellipse(shape)
        end
      end
      
      # @see #create_basic_shape_stamp
      def create_line_stamp(shape)
        create_pdf_stamp(shape) do
          @pdf.draw_shape_line(shape)
        end
      end
      
      # @see #create_basic_shape_stamp
      def create_text_stamp(shape)
        create_pdf_stamp(shape) do
          @pdf.draw_shape_text(shape)
        end
      end
    end
    
  end
end
