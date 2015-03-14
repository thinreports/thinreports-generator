# coding: utf-8

module Thinreports
  module Generator::PDF::Drawer
    
    # @private
    class Page < Base
      # @param (see PDF::Drawer::Base#initialize)
      def initialize(pdf, format)
        super
        @lists = {}
      end
      
      # @param [Thinreports::Core::Page] page
      def draw(page)
        manager = page.manager

        manager.format.shapes.each_key do |id|
          next unless shape = manager.final_shape(id)

          shape = shape.internal

          if shape.type_of?(:pageno)
            # Do not draw pageno if is not for Report
            draw_pageno_shape(shape, page) if page.count? && shape.for_report?
          else
            draw_shape(shape)
          end
        end
      end
      
    private

      def draw_shape(shape)
        case
        when shape.type_of?(:tblock)
          draw_tblock_shape(shape)
        when shape.type_of?(:list)
          draw_list_shape(shape)
        when shape.type_of?(:iblock)
          draw_iblock_shape(shape)
        else
          id = shape.identifier
          unless @stamps.include?(id)
            create_basic_shape_stamp(shape)
            @stamps << id
          end
          pdf_stamp(shape)
        end
      end
      
      def draw_pageno_shape(shape, page)
        @pdf.draw_shape_pageno(shape, page.no, page.report.page_count)
      end

      # @see #draw_shape
      def draw_list_shape(shape)
        drawer = @lists[shape.id] ||= List.new(@pdf, shape.format)
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
      
      # @param [Thinreports::Core::Shape::Base::Internal] shape
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
