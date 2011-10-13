# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Basic::Interface < Base::Interface
      internal_delegators :type
      
      # @return [String]
      def id
        internal.id.dup
      end
      
      # @param [Boolean] visibility
      # @return [self]
      def visible(visibility)
        internal.style.visible = visibility
        self
      end
      
      # @return [Boolean]
      def visible?
        internal.style.visible
      end
      
      # @overload style(style_name)
      #   @param [Symbol] style_name
      #   @return [Object]
      # @overload style(style_name, value)
      #   @param [Symbol] style_name
      #   @param [String, Symbol, Number, Array] value
      #   @return [self]
      # @overload style(style_name, value1, value2)
      #   @param [Symbol] style_name
      #   @param [String, Number] value1
      #   @param [String, Number] value2
      #   @return [self]
      def style(*args)
        case args.length
        when 1
          internal.style[args.first]
        when 2
          internal.style[args.first] = args.last
          self
        when 3
          internal.style[args.shift] = args
          self
        else
          raise ArgumentError, '#style requires 1 or 2, 3 arguments'
        end
      end
      
      # @param [Hash] settings :style_name => value
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
      
      # @see ThinReports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        Basic::Internal.new(parent, format)
      end
    end
    
  end
end