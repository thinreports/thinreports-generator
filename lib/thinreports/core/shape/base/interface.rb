# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    # @abstract
    class Base::Interface
      extend ::Forwardable
      
      def self.internal_delegators(*args)
        def_delegators :internal, *args
      end
      private_class_method :internal_delegators
      
      attr_reader :internal
      
      def initialize(parent, format, internal = nil)
        @internal = internal || init_internal(parent, format)
      end
      
      def copy(parent)
        self.class.new(parent, internal.format, internal.copy(parent))
      end
      
    private
    
      # @param [ThinReports::Core::Page, ThinReports::Core::Shape::List::SectionInterface] parent
      # @param [ThinReports::Core::Shape::Basic::Format] format
      # @return [ThinReports::Core::Shape::Basic::Internal]
      # @abstract
      def init_internal(parent, format)
        raise NotImplementedError
      end
    end
    
  end
end