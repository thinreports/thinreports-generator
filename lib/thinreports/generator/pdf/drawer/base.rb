# coding: utf-8

module ThinReports
  module Generator
    
    # @abstract
    class Pdf::Drawer::Base
      # @param [ThinReports::Generator::Pdf::Document] pdf
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
        id = shape.id.dup
        id << shape.attrs.values_at('fill', 'stroke').join unless shape.attrs.empty?
        id.gsub(/#/, '')
      end
      
      # @overload pdf_stamp('stamp_id')
      #   @param [String] shape
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
