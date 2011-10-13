# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    # @abstract
    class Base::Internal
      extend ::Forwardable
      
      def self.format_delegators(*args)
        def_delegators :format, *args
      end
      private_class_method :format_delegators
      
      attr_reader :parent
      attr_reader :format
      attr_writer :style
      attr_accessor :states
      
      def initialize(parent, format)
        @parent = parent
        @format = format
        @states = {}
        @style  = nil
        
        @finalized_attributes = nil
      end
      
      def style
        raise NotImplementedError
      end
      
      def copy(new_parent, &block)
        new_internal = self.class.new(new_parent, format)
        new_internal.style  = style.copy
        new_internal.states = states.simple_deep_copy
        
        block.call(new_internal) if block_given?
        new_internal
      end
      
      def switch_parent!(new_parent)
        @parent = new_parent
        self
      end
      
      def type_of?(type_name)
        raise NotImplementedError
      end
    end
    
  end
end