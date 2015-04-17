# coding: utf-8

module Thinreports
  module Report

    class Internal
      attr_reader :pages
      attr_reader :page
      attr_reader :page_count
      attr_reader :default_layout
      attr_reader :layout_registry
      attr_reader :events

      attr_accessor :page_create_handler
      attr_accessor :generate_handler

      # @param [Thinreports::Report::Base] report
      # @param options (see Thinreports::Report::Base#initialize)
      def initialize(report, options)
        @report = report
        # Default layout
        @default_layout = prepare_layout(options[:layout])

        @layout_registry = {}
        @finalized  = false
        @pages      = []
        @page       = nil
        @page_count = 0

        @page_create_handler = nil
        @generate_handler = nil

        @events = Report::Events.new
      end

      # @see Thinreports::Report::Base#use_layout
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
        finalize_current_page(at: :copy)
        insert_page(page.copy)
      end

      def finalize
        unless finalized?
          finalize_current_page
          @finalized = true

          # [DEPRECATION] Please use Report::Base#on_generate callback instead.
          events.dispatch(Report::Events::Event.new(:generate,
                                                    @report, nil, pages))

          @generate_handler.call(pages) if @generate_handler
        end
      end

      def finalized?
        @finalized
      end

      def load_layout(id_or_filename)
        return @default_layout if id_or_filename.nil?

        layout = case id_or_filename
        when Symbol
          layout_registry[id_or_filename]
        when String
          prepare_layout(id_or_filename)
        else
          raise ArgumentError, 'Invalid argument for layout.'
        end
        @default_layout = layout unless @default_layout
        layout
      end

    private

      def insert_page(new_page)
        @pages << new_page

        if new_page.count?
          @page_count += 1
          new_page.no = @page_count
        end

        unless new_page.blank?
          # [DEPRECATION] Please use #on_page_create callback instead.
          events.dispatch(Report::Events::Event.new(:page_create,
                                                    @report,
                                                    new_page))
          @page_create_handler.call(new_page) if @page_create_handler
        end
        @page = new_page
      end

      # @param (see Thinreports::Report::Page#finalize)
      def finalize_current_page(options = {})
        page.finalize(options) unless page.nil? || page.blank?
      end

      def prepare_layout(layout)
        return nil if layout.nil?

        case layout
        when String
          init_layout(layout)
        # @note Currently not used. Since 0.6.0?
        when Thinreports::Layout::Base
          layout
        else
          raise ArgumentError, 'Invalid argument for layout.'
        end
      end

      def init_layout(filename, id = nil)
        Thinreports::Layout.new(filename, id: id)
      end
    end

  end
end
