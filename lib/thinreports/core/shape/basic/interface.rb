# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Basic::Interface < Base::Interface
      internal_delegators :visible?, :id, :type
      
      # @param [Boolean] visibility
      # @return [self]
      def visible(visibility)
        internal.visible(visibility)
        self
      end
      
      # @param [Symbol] style_name
      # @param [String] value
      # @return [self]
      def style(style_name, value)
        unless internal.available_style?(style_name)
          raise ThinReports::Errors::UnknownShapeStyleName
        end
        internal.svg_attr(style_name, value)
        self
      end
      
      # @param [Hash] settings
      # @return [self]
      def styles(settings)
        settings.each{ |args| style(*args) }
        self
      end
      
      # @see #visible
      # @return [self]
      def hide
        visible(false)
        self
      end
      
      # @see #visible
      # @return [self]
      def show
        visible(true)
        self
      end
    
    private
      
      # @private
      def init_internal(parent, format)
        Basic::Internal.new(parent, format)
      end
    end
    
  end
end