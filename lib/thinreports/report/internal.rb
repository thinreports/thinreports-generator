# frozen_string_literal: true

module Thinreports
  module Report
    class Internal
      attr_reader :pages
      attr_reader :page
      attr_reader :page_count
      attr_reader :default_layout
      attr_reader :layout_registry

      attr_accessor :page_create_handler

      # @param [Thinreports::Report::Base] report
      # @param options (see Thinreports::Report::Base#initialize)
      def initialize(report, options)
        @report = report
        @default_layout = options[:layout] ? init_layout(options[:layout]) : nil

        @layout_registry = {}
        @finalized = false
        @pages = []
        @page = nil
        @page_count = 0

        @page_create_handler = nil
      end

      # @see Thinreports::Report::Base#use_layout
      def register_layout(layout, options = {})
        if options.empty? || options[:default]
          @default_layout = init_layout(layout)
        else
          id = options[:id].to_sym

          raise ArgumentError, "Id :#{id} is already in use." if layout_registry.key?(id)
          layout_registry[id] = init_layout(layout, id)
        end
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
        return if finalized?

        finalize_current_page
        @finalized = true
      end

      def finalized?
        @finalized
      end

      def load_layout(id_or_filename)
        return @default_layout if id_or_filename.nil?

        layout =
          case id_or_filename
          when Symbol
            layout_registry[id_or_filename]
          when String
            init_layout(id_or_filename)
          else
            raise ArgumentError, 'Invalid argument for layout.'
          end

        @default_layout ||= layout
        layout
      end

      private

      def insert_page(new_page)
        @pages << new_page

        if new_page.count?
          @page_count += 1
          new_page.no = @page_count
        end

        @page_create_handler.call(new_page) if !new_page.blank? && @page_create_handler
        @page = new_page
      end

      # @param (see Thinreports::Report::Page#finalize)
      def finalize_current_page(options = {})
        page.finalize(options) unless page.nil? || page.blank?
      end

      def init_layout(filename, id = nil)
        Thinreports::Layout.new(filename, id: id)
      end
    end
  end
end
