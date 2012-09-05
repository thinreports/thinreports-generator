# coding: utf-8

module ThinReports
  module Report
    
    # @private
    class Internal
      attr_reader :pages
      attr_reader :page
      attr_reader :page_count
      attr_reader :default_layout
      attr_reader :layout_registry
      attr_reader :events
      
      # @param [ThinReports::Report::Base] report
      # @param options (see ThinReports::Report::Base#initialize)
      def initialize(report, options)
        @report = report
        # Default layout
        @default_layout = prepare_layout(options[:layout])

        @layout_registry = {}
        @finalized  = false
        @pages      = []
        @page       = nil
        @page_count = 0
        
        @events = Report::Events.new
      end
      
      # @see ThinReports::Report::Base#use_layout
      def register_layout(layout, options = {}, &block)
        layout = if options.empty? || options[:default]
          @default_layout = init_layout(layout)
        else
          id = options[:id].to_sym
          
          if layout_registry.key?(id)
            raise ArgumentError, "Id :#{id} is already in use."
          end
          layout_registry[id] = init_layout(layout, id)
        end
        layout.config(&block)
      end
      
      def add_page(new_page)
        finalize_current_page
        insert_page(new_page)
      end
      
      def copy_page
        finalize_current_page(:at => :copy)
        insert_page(page.copy)
      end
      
      def finalize
        unless finalized?
          finalize_current_page
          @finalized = true
          
          # Dispatch event on before generate.
          events.dispatch(Report::Events::Event.new(:generate,
                                                    @report, nil, pages))
        end
      end
      
      def finalized?
        @finalized
      end
      
      def load_layout(layout)
        return @default_layout if layout.nil?
        
        case layout
        when Symbol
          layout_registry[layout]
        when String
          prepare_layout(layout)
        else
          raise ArgumentError, 'Invalid argument for layout.'
        end
      end
      
    private
      
      def insert_page(new_page)
        @pages << new_page
        
        if new_page.count?
          @page_count += 1
          new_page.no = @page_count
        end
        # Dispatch event on +before+ page create.
        # But do not dispatch if page is blank-page.
        unless new_page.blank?
          events.dispatch(Report::Events::Event.new(:page_create,
                                                    @report,
                                                    new_page))
        end
        @page = new_page
      end
      
      # @param (see ThinReports::Core::Page#finalize)
      def finalize_current_page(options = {})
        page.finalize(options) unless page.blank?        
      end
      
      def prepare_layout(layout)
        return nil if layout.nil?
        
        case layout
        when String
          init_layout(layout)
        # @note Currently not used. Since 0.6.0?
        when ThinReports::Layout::Base
          layout
        else
          raise ArgumentError, 'Invalid argument for layout.'
        end
      end
      
      def init_layout(filename, id = nil)
        ThinReports::Layout.new(filename, :id => id)
      end
    end
    
  end
end
