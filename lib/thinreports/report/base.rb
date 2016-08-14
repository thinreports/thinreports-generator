# coding: utf-8

module Thinreports
  module Report

    class Base
      extend  Forwardable
      include Utils

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

      # @return [Thinreports::Report::Internal]
      attr_reader :internal

      # @return [Integer]
      attr_reader :start_page_number

      # @return [Thinreports::Report::Page]
      def_delegator :internal, :page

      # @return [Integer]
      def_delegator :internal, :page_count

      # @return [Array<Thinreports::Report::Page>]
      def_delegator :internal, :pages

      # @return [Thinreports::Layout::Base]
      def_delegator :internal, :default_layout

      # @param [Hash] options
      # @option options [String, nil] :layout (nil)
      def initialize(options = {})
        @internal = Report::Internal.new(self, options)
        @start_page_number = 1
      end

      # @yield [page]
      # @yieldparam [Thinreports::Report::Page] page
      # @example
      #   report.on_page_create do |page|
      #     page.item(:header_title).value = 'Title'
      #   end
      def on_page_create(&block)
        internal.page_create_handler = block
      end

      # @param [Integer] page_number
      def start_page_number_from(page_number)
        @start_page_number = page_number
      end

      # @param [String] layout filename of layout file
      # @param [Hash] options
      # @option options [Boolean] :default (true)
      # @option options [Symbol] :id (nil)
      # @example
      #   report.use_layout '/path/to/default_layout.tlf' # Default layout
      #   report.use_layout '/path/to/default_layout.tlf', default: true
      #   report.use_layout '/path/to/other_layout', id: :other_layout
      def use_layout(layout, options = {})
        internal.register_layout(layout, options)
      end

      # @example
      #   page = report.start_new_page
      #
      #   report.start_new_page do |page|
      #     page.item(:text).value = 'value'
      #   end
      #
      #   report.use_layout 'foo.tlf', default: true
      #   report.use_layout 'bar.tlf', id: :bar
      #
      #   report.start_new_page                   # Use 'foo.tlf'
      #   report.start_new_page layout: :bar      # Use 'bar.tlf'
      #   report.start_new_page layout: 'boo.tlf' # Use 'boo.tlf'
      # @param [Hash] options
      # @option options [String, Symbol] :layout (nil)
      # @option options [Boolean] :count (true)
      # @yield [page]
      # @yieldparam [Thinreports::Report::Page] page
      # @return [Thinreports::Report::Page]
      def start_new_page(options = {}, &block)
        layout = internal.load_layout(options.delete(:layout))

        raise Thinreports::Errors::NoRegisteredLayoutFound unless layout

        page = internal.add_page(Report::Page.new(self, layout, options))
        call_block_in(page, &block)
      end

      # @param [Hash] options
      # @option options [Boolean] :count (true)
      # @return [Thinreports::Report::BlankPage]
      def add_blank_page(options = {})
        internal.add_page(Report::BlankPage.new(options[:count]))
      end
      alias_method :blank_page, :add_blank_page

      # @param [Symbol, nil] id
      # @return [Thinreports::Layout::Base]
      def layout(id = nil)
        if id
          internal.layout_registry[id] ||
            raise(Thinreports::Errors::UnknownLayoutId)
        else
          internal.default_layout
        end
      end

      # @overload generate(options = {})
      #   @param [Hash] options ({})
      #   @return [String]
      # @overload generate(type, options = {})
      #   This way has been DEPRECATED. Use instead #generate(options = {}).
      #   @param [Symbol] type
      #   @return [String]
      # @example Generate PDF data
      #   report.generate # => "%PDF-1.4...."
      # @example Create a PDF file
      #   report.generate(filename: 'foo.pdf')
      def generate(*args)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        filename = options.delete(:filename)
        generator = Thinreports::Generator::PDF.new(self, options)

        generator.generate(filename)
      end

      # @see Thinreports::Core::Shape::Manager::Target#list
      def list(id = nil, &block)
        start_new_page if page.nil? || page.finalized?
        page.list(id, &block)
      end

      def_delegators :internal, :finalize, :finalized?
    end

  end
end
