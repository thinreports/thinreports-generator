# coding: utf-8

module ThinReports
  module Core
    
    class BlankPage
      # @return [Integer]
      attr_accessor :no
      
      # @param [Boolean] count (nil)
      def initialize(count = nil)
        @count = count.nil? ? true : count
      end
      
      # @return [Boolean]
      def count?
        @count
      end
      
      # @return [Boolean] (true)
      def blank?
        true
      end
    end
    
    class Page < BlankPage
      include Core::Shape::Manager::Target
      
      # @return [ThinReports::Report::Base]
      # @private
      attr_reader :report
      
      # @return [ThinReports::Layout::Base]
      attr_reader :layout
      
      # @param [ThinReports::Report::Base] report
      # @param [ThinReports::Layout::Base] layout
      def initialize(report, layout)
        super(true)
        
        @report    = report
        @layout    = layout
        @finalized = false
        
        initialize_manager(layout.format) do |f|
          Core::Shape::Interface(self, f)
        end
      end
      
      # @return [Boolean] (false)
      def blank?
        false
      end
      
      # @private
      def copy
        new_page = self.class.new(report, layout)
        
        manager.shapes.each do |id, shape|
          new_shape = shape.copy(new_page)
          new_page.manager.shapes[id] = new_shape
          
          if new_shape.internal.type_of?(:list)
            new_page.manager.lists[id] = new_shape
          end
        end
        new_page
      end
      
      # @param [Hash] options
      # @option options [:create, :copy] :at (:create)
      # @private
      def finalize(options = {})
        at = options[:at] || :create
        
        # For list shapes.
        if at == :create
          manager.lists.values.each {|list| list.manager.finalize }
        end
        
        @finalized = true
      end
      
      # @private
      def finalized?
        @finalized
      end
    end
    
  end
end
