# coding: utf-8

module ThinReports
  module Core::Shape
    
    class ImageBlock::Interface < Basic::BlockInterface
      # @see #value
      alias_method :src, :value
      
    private
      
      # @see ThinReports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        ImageBlock::Internal.new(parent, format)
      end
    end
    
  end
end