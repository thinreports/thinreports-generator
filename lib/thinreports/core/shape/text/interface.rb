module Thinreports
  module Core::Shape
    
    class Text::Interface < Basic::Interface
    private
    
      # @see Thinreports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        Text::Internal.new(parent, format)
      end
    end
    
  end
end