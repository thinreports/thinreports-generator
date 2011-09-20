# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class ImageBlock::Internal < Basic::BlockInternal
      alias_method :src, :read_value
      
      def type_of?(type_name)
        type_name == :iblock || super
      end
    end
    
  end
end