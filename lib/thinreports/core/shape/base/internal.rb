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
      
      AVAILABLE_STYLES = [:fill, :stroke]
      
      attr_reader :parent
      attr_reader :format
      attr_accessor :attrs, :states
      
      def initialize(parent, format)
        @parent = parent
        @format = format
        
        @states = {}
        @attrs  = {}
        
        @finalized_attributes = nil
      end
      
      def attributes
        @finalized_attributes ||= (format.svg_attrs || {}).merge(attrs)
      end
      
      def copy(new_parent, &block)
        new_internal = self.class.new(new_parent, format)
        new_internal.attrs  = attrs.simple_deep_copy
        new_internal.states = states.simple_deep_copy
        
        block.call(new_internal) if block_given?
        new_internal
      end
      
      def switch_parent!(new_parent)
        @parent = new_parent
        self
      end
      
      def available_style?(style_name)
        AVAILABLE_STYLES.include?(style_name)
      end
      
      def type_of?(type_name)
        raise NotImplementedError
      end
    end
    
  end
end