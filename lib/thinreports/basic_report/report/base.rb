# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Report
      class Base
        extend  Forwardable
        include Utils

        class << self
          # @param options (see #initialize)
          # @option options (see #initialize)
          # @yield [report]
          # @yieldparam [Thinreports::BasicReport::Report::Base] report
          # @return [Thinreports::BasicReport::Report::Base]
          def create(options = {}, &block)
            raise ArgumentError, '#create requires a block' unless block_given?

            report = new(options)
            call_block_in(report, &block)
            report.finalize

            report
          end

          # @param layout (see #initialize)
          # @param filename (see #generate)
          # @param security (see #generate)
          # @param [Hash] report ({}) DEPRECATED. Options for Report.
          # @param [Hash] generator ({}) DEPRECATED. Options for Generator.
          # @yield (see .create)
          # @yieldparam (see .create)
          # @return [String]
          def generate(layout: nil, filename: nil, security: nil, report: {}, generator: {}, &block)
            raise ArgumentError, '#generate requires a block' unless block_given?

            if report.any? || generator.any?
              warn '[DEPRECATION] :report and :generator argument has been deprecated. ' \
                   'Use :layout and :filename, :security argument instead.'
            end

            layout ||= report[:layout]
            filename ||= generator[:filename]
            security ||= generator[:security]

            report = create(layout: layout, &block)
            report.generate(filename: filename, security: security)
          end
        end

        # @return [Thinreports::BasicReport::Report::Internal]
        attr_reader :internal

        # @return [Integer]
        attr_reader :start_page_number

        # @return [Thinreports::BasicReport::Report::Page]
        def_delegator :internal, :page

        # @return [Integer]
        def_delegator :internal, :page_count

        # @return [Array<Thinreports::BasicReport::Report::Page>]
        def_delegator :internal, :pages

        # @return [Thinreports::BasicReport::Layout::Base]
        def_delegator :internal, :default_layout

        # @param [Hash] options
        # @option options [String, nil] :layout (nil)
        def initialize(options = {})
          @internal = Report::Internal.new(self, options)
          @start_page_number = 1
        end

        # @yield [page]
        # @yieldparam [Thinreports::BasicReport::Report::Page] page
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
        # @yieldparam [Thinreports::BasicReport::Report::Page] page
        # @return [Thinreports::BasicReport::Report::Page]
        def start_new_page(options = {}, &block)
          layout = internal.load_layout(options.delete(:layout))

          raise Thinreports::BasicReport::Errors::NoRegisteredLayoutFound unless layout

          page = internal.add_page(Report::Page.new(self, layout, options))
          call_block_in(page, &block)
        end

        # @param [Hash] options
        # @option options [Boolean] :count (true)
        # @return [Thinreports::BasicReport::Report::BlankPage]
        def add_blank_page(options = {})
          internal.add_page(Report::BlankPage.new(options[:count]))
        end
        alias blank_page add_blank_page

        # @param [Symbol, nil] id
        # @return [Thinreports::BasicReport::Layout::Base]
        def layout(id = nil)
          if id
            internal.layout_registry[id] ||
              raise(Thinreports::BasicReport::Errors::UnknownLayoutId)
          else
            internal.default_layout
          end
        end

        # @param [String] filename
        # @param [Hash] security (see http://prawnpdf.org/api-docs/2.0/Prawn/Document/Security.html#encrypt_document-instance_method)
        # @param [String] title Value of the title attribute of the PDF document metadata.
        #   if nil, the title of the default layout file is set.
        # @return [String]
        # @example Generate PDF data
        #   report.generate # => "%PDF-1.4...."
        # @example Create a PDF file
        #   report.generate(filename: 'foo.pdf')
        def generate(filename: nil, security: nil, title: nil)
          Thinreports::BasicReport::Generator::PDF.new(self, security: security, title: title).generate(filename)
        end

        # @see Thinreports::BasicReport::Core::Shape::Manager::Target#list
        def list(id = nil, &block)
          start_new_page if page.nil? || page.finalized?
          page.list(id, &block)
        end

        def_delegators :internal, :finalize, :finalized?
      end
    end
  end
end
