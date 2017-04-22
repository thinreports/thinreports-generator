module Thinreports
  module Core::Shape

    class ImageBlock::Interface < Basic::BlockInterface
      # @see #value
      alias_method :src, :value
      # @see #value=
      alias_method :src=, :value=

    private

      # @see Thinreports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        ImageBlock::Internal.new(parent, format)
      end
    end

  end
end
