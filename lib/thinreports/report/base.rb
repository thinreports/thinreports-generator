# coding: utf-8

module ThinReports
  module Report
  
    class Base
      # @return [ThinReports::Report::Internal]
      # @private
      attr_reader :internal
      
      class << self
        # @param options (see #initialize)
        # @option options (see #initialize)
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
        
        # @overload generate(type, options = {}, &block)
        #   @param [Symbol] type
        #   @param [Hash] options
        #   @option options [Hash] :report ({}) Options for Report.
        #   @option options [Hash] :generator ({}) Options for Generator.
        # @overload generate(options = {}, &block)
        #   @param [Hash] options
        #   @option options [Hash] :report ({}) Options for Report.
        #   @option options [Hash] :generator ({}) Options for Generator.
        # @yield (see .create)
        # @yieldparam (see .create)
        # @return [String]
        def generate(*args, &block)
          raise ArgumentError, '#generate requires a block' unless block_given?
          
          options = args.last.is_a?(::Hash) ? args.pop : {}
          report  = create(options[:report] || {}, &block)
          report.generate(*args.push(options[:generator] || {}))
        end
        
        # @overload generate_file(type, filename, options = {}, &block)
        # @overload generate_file(filename, options = {}, &block)
        # @param filename (see #generate_file)
        # @yield (see .create)
        # @yieldparam (see .create)
        # @see .generate
        # @return [void]
        def generate_file(*args, &block)
          raise ArgumentError, '#generate_file requires a block' unless block_given?
          
          options = args.last.is_a?(::Hash) ? args.pop : {}
          report  = create(options[:report] || {}, &block)
          report.generate_file(*args.push(options[:generator] || {}))
        end
      end
      
      # @param [Hash] options
      # @option options [String, nil] :layout (nil)
      def initialize(options = {})
        @internal = Report::Internal.new(self, options)
      end
      
      # @param [String] layout path to layout-file.
      # @param [Hash] options
      # @option options [Boolean] :default (true)
      # @option options [Symbol] :id (nil)
      # @yield [config]
      # @yieldparam [ThinReports::Layout::Configuration] config
      # @return [void]
      def use_layout(layout, options = {}, &block)
        internal.register_layout(layout, options, &block)
      end
      
      # @param [Hash] options
      # @option options [String, Symbol] :layout (nil)
      # @yield [page]
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
      
      # @overload generate(type, options = {})
      #   Specify the generator type.
      #   @param [Symbol] type
      # @overload generate(options = {})
      #   Using the default generator type.
      # @param [Hash] options ({})
      # @return [String]
      def generate(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        type    = args.first || ThinReports.config.generator.default
        ThinReports::Generator.new(type, self, options).generate
      end
      
      # @overload generate_file(type, filename, options = {})
      #   @param type (#generate)
      # @overload generate_file(filename, options = {})
      # @param [String] filename
      # @param options (see #generate)
      # @return [void]
      def generate_file(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        args.unshift(ThinReports.config.generator.default) if args.size == 1
        type, filename = args
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
      
      # @return [void]
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