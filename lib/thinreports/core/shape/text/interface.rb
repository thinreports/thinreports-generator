# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Text::Interface < Basic::Interface
    private
    
      # @see ThinReports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        Text::Internal.new(parent, format)
      end
    end
    
  end
end