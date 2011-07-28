# coding: utf-8

module ThinReports
  module Report
  
    class Base
      # @return [ThinReports::Report::Internal]
      # @private
      attr_reader :internal
      
      class << self
        # @param options (see #initialize)
        # @yield [report]
        # @yieldparam [ThinReports::Report::Base] report
        # @return [ThinReports::Report::Base]
        def create(options = {}, &block)
          unless block_given?
            raise ArgumentError, '#create requires a block'
          end
          report = new(options)
          block_exec_on(report, &block)
          report.finalize
          
          report
        end
        
        # @param [Symbol] type
        # @param [Hash] options
        # @option options [Hash] :report Options for Report (see #initialize)
        # @option options [Hash] :generator Options for Generator.
        # @yield (see #create)
        # @return [String]
        def generate(type, options = {}, &block)
          init_generate_params(options, &block)
          
          create(options[:report], &block).generate(type, options[:generator])
        end
        
        # @param [Symbol] type
        # @param [String] filename
        # @param options (see #generate)
        # @yield (see #create)
        def generate_file(type, filename, options = {}, &block)
          init_generate_params(options, &block)
          
          create(options[:report], &block).
              generate_file(type, filename, options[:generator])
        end
        
      private
        
        # @param (see #generate)
        # @private
        def init_generate_params(options, &block)
          unless block_given?
            raise ArgumentError, '#generate or #generate_file requires a block'
          end
          options[:report]    ||= {}
          options[:generator] ||= {}
        end
      end
      
      # @param [Hash] options
      # @option options [String, nil] :layout (nil)
      def initialize(options = {})
        @internal = Report::Internal.new(self, options)
      end
      
      # @param [String] path of layout-file.
      # @param [Hash] options
      # @option options [Boolean] :default (true)
      # @option options [Symbol] :id (nil)
      # @yield [config,]
      # @yieldparam [ThinReports::Layout::Configuration] config
      def use_layout(layout, options = {}, &block)
        internal.register_layout(layout, options, &block)
      end
      
      # @param [Hash] options
      # @option options [String, Symbol] :layout (nil)
      # @yield [page,]
      # @yieldparam [ThinReports::Core::Page] page
      # @return [ThinReports::Core::Page]
      def start_new_page(options = {}, &block)
        unless layout = internal.load_layout(options[:layout])
          raise ThinReports::Errors::NoRegisteredLayoutFound
        end
        
        page = internal.add_page(layout.init_new_page(self))
        block_exec_on(page, &block)
      end
      
      # @param [Hash] options
      # @option options [Boolean] :count (true)
      # @return [ThinReports::Core::BlankPage]
      def add_blank_page(options = {})
        internal.add_page(Core::BlankPage.new(options[:count]))
      end
      alias_method :blank_page, :add_blank_page
      
      # @param [Symbol, nil] id Return the default layout
      #   if nil (see #default_layout).
      # @return [ThinReports::Layout::Base]
      def layout(id = nil)
        if id
          internal.layout_registry[id] ||
            raise(ThinReports::Errors::UnknownLayoutId)
        else
          internal.default_layout
        end
      end
      
      # @return [ThinReports::Layout::Base]
      def default_layout
        internal.default_layout
      end
      
      # @param [Symbol] type
      # @param options (see ThinReports::Generator)
      # @return [String]
      def generate(type, options = {})
        ThinReports::Generator.new(type, self, options).generate
      end
      
      # @param type (see #generate)
      # @param [String] filename
      # @param options (see #generate)
      def generate_file(type, filename, options = {})
        ThinReports::Generator.new(type, self, options).generate_file(filename)
      end
      
      # @return [ThinReports::Report::Events]
      def events
        internal.events
      end
      
      # @return [ThinReports::Core::Page, nil]
      def page
        internal.page
      end
      
      # @return [Integer]
      def page_count
        internal.page_count
      end
      
      # @private
      def finalize
        internal.finalize
      end
      
      # @return [Boolean]
      # @private
      def finalized?
        internal.finalized?
      end
    end
  
  end
end