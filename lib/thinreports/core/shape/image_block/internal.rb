# coding: utf-8

module Thinreports
  module Core::Shape

    class ImageBlock::Internal < Basic::BlockInternal
      alias_method :src, :read_value

      def type_of?(type_name)
        type_name == :iblock || super
      end
    end

  end
end
