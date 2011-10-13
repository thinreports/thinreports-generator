# coding: utf-8

module ThinReports
  module Generator
    
    # @abstract
    # @private
    class PDF::Drawer::Base
      # @param [ThinReports::Generator::PDF::Document] pdf
      # @param [ThinReports::Core::Shape::Manager::Format] format
      def initialize(pdf, format)
        @pdf     = pdf
        @format  = format
        @stamps  = []
        @draw_at = nil
      end
      
      # @abstract
      def draw
        raise NotImplementedError
      end
      
    private
      
      # @param [ThinReports::Core::Shape::Base::Internal] shape
      # @return [String]
      def pdf_stamp_id(shape)
        "#{@format.identifier}#{shape_stamp_id(shape)}"
      end
      
      # @see #pdf_stamp_id
      def shape_stamp_id(shape)
        "#{shape.id}#{shape.style.identifier}"
      end
      
      # @overload pdf_stamp(shape_id)
      #   @param [String] shape_id
      # @overload pdf_stamp(shape)
      #   @param [ThinReports::Core::Shape::Base::Internal] shape
      def pdf_stamp(shape)
        unless shape.is_a?(::String)
          shape = pdf_stamp_id(shape)
        end
        @pdf.stamp(shape, @draw_at)
      end
      
      # @param [ThinReports::Core::Shape::Base::Internal] shape
      def create_pdf_stamp(shape, &block)
        @pdf.create_stamp(pdf_stamp_id(shape), &block)
      end
    end
    
  end
end
