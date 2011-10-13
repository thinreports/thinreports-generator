# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class List::PageState < Basic::Internal
      attr_reader :rows
      attr_accessor :height
      attr_accessor :header
      
      def initialize(*args)
        super(*args)
        
        @rows      = []
        @header    = nil
        @height    = 0
        @finalized = false
      end
      
      def style
        @style ||= Style::Basic.new(format)
      end
      
      def finalized?
        @finalized
      end
      
      def finalized!
        @finalized = true
      end
      
      def type_of?(type_name)
        type_name == :list
      end
    end
    
    # Alias to List::PageState.
    # @see ThinReports::Core::Shape::List::PageState
    # @private
    List::Internal = List::PageState
    
  end
end