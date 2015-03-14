# coding: utf-8

module Thinreports
  module Report

    class Base
      include Utils

      # @return [Thinreports::Report::Internal]
      # @private
      attr_reader :internal

      # @return [Integer]
      attr_reader :start_page_number

      class << self
        # @param options (see #initialize)
        # @option options (see #initialize)
        # @yield [report]
        # @yieldparam [Thinreports::Report::Base] report
        # @return [Thinreports::Report::Base]
        def create(options = {}, &block)
          unless block_given?
            raise ArgumentError, '#create requires a block'
          end
          report = new(options)
          call_block_in(report, &block)
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

          report_opts, generator_opts = extract_options!(args)

          report = create(report_opts, &block)
          report.generate(*args.push(generator_opts))
        end

        # @param [Array] args
        # @return [Array<Hash>]
        def extract_options!(args)
          if args.last.is_a?(::Hash)
            options = args.pop

            generator = options.delete(:generator) || {}
            report    = options.delete(:report) || {}

            if options.key?(:layout)
              report[:layout] = options.delete(:layout)
            end
            [report, generator.merge(options)]
          else
            [{}, {}]
          end
        end
      end

      # @param [Hash] options
      # @option options [String, nil] :layout (nil)
      def initialize(options = {})
        @internal = Report::Internal.new(self, options)
        @start_page_number = 1
      end

      # @param [Integer] page_number
      def start_page_number_from(page_number)
        @start_page_number = page_number
      end

      # @param [String] layout path to layout-file.
      # @param [Hash] options
      # @option options [Boolean] :default (true)
      # @option options [Symbol] :id (nil)
      # @yield [config]
      # @yieldparam [Thinreports::Layout::Configuration] config
      # @return [void]
      def use_layout(layout, options = {}, &block)
        internal.register_layout(layout, options, &block)
      end

      # @param [Hash] options
      # @option options [String, Symbol] :layout (nil)
      # @option options [Boolean] :count (true)
      # @yield [page]
      # @yieldparam [Thinreports::Report::Page] page
      # @return [Thinreports::Report::Page]
      def start_new_page(options = {}, &block)
        unless layout = internal.load_layout(options.delete(:layout))
          raise Thinreports::Errors::NoRegisteredLayoutFound
        end

        page = internal.add_page(layout.new_page(self, options))
        call_block_in(page, &block)
      end

      # @param [Hash] options
      # @option options [Boolean] :count (true)
      # @return [Thinreports::Report::BlankPage]
      def add_blank_page(options = {})
        internal.add_page(Report::BlankPage.new(options[:count]))
      end
      alias_method :blank_page, :add_blank_page

      # @param [Symbol, nil] id Return the default layout
      #   if nil (see #default_layout).
      # @return [Thinreports::Layout::Base]
      def layout(id = nil)
        if id
          internal.layout_registry[id] ||
            raise(Thinreports::Errors::UnknownLayoutId)
        else
          internal.default_layout
        end
      end

      # @return [Thinreports::Layout::Base]
      def default_layout
        internal.default_layout
      end

      # @overload generate(type, options = {})
      #   Specify the generator type.
      #   @param [Symbol] type
      #   @return [String]
      # @overload generate(options = {})
      #   Using the default generator type.
      #   @param [Hash] options ({})
      #   @return [String]
      # @example Generate the PDF data
      #   report.generate(:pdf) #=> "%PDF-1.4...."
      #
      #   # Or, you can omit the type of generator
      #   report.generate
      # @example Create the PDF file (Since v0.8)
      #   report.generate(:pdf, filename: 'foo.pdf')
      def generate(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        type = args.first || Thinreports.config.generator.default
        filename = options.delete(:filename)
        generator = Thinreports::Generator.new(type, self, options)

        generator.generate(filename)
      end

      # @see Thinreports::Core::Shape::Manager::Target#list
      def list(id = nil, &block)
        start_new_page if page.nil? || page.finalized?
        page.list(id, &block)
      end

      # @return [Thinreports::Report::Events]
      def events
        internal.events
      end

      # @return [Thinreports::Report::Page, nil]
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
