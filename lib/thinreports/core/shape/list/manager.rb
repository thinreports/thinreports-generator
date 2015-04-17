# coding: utf-8

module Thinreports
  module Core::Shape

    class List::Manager
      include Utils

      # @return [Thinreports::Core::Shape::List::Configuration]
      attr_reader :config

      # @return [Thinreports::Core::Shape:::List::Page]
      attr_reader :current_page

      # @return [Thinreports::Core::Shape::List::PageState]
      attr_reader :current_page_state

      # @return [Integer]
      attr_accessor :page_count

      # @return [Proc]
      attr_accessor :page_finalize_handler

      # @return [Proc]
      attr_accessor :page_footer_handler

      # @return [Proc]
      attr_accessor :footer_handler

      # @param [Thinreports::Core::Shape::List::Page] page
      def initialize(page)
        switch_current!(page)

        @config = init_config
        @finalized = false
        @page_count = 0

        @page_finalize_handler = nil
        @page_footer_handler = nil
        @footer_handler = nil
      end

      # @param [Thinreports::Core::Shape::List::Page] page
      # @return [Thinreports::Core::Shape::List::Manager]
      def switch_current!(page)
        @current_page       = page
        @current_page_state = page.internal
        self
      end

      # @yield [new_list]
      # @yieldparam [Thinreports::Core::Shape::List::Page] new_list
      def change_new_page(&block)
        finalize_page
        new_page = report.internal.copy_page

        if block_given?
          block.call(new_page.list(current_page.id))
        end
      end

      # @param [Hash] values ({})
      # @yield [header]
      # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] header
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      # @raise [Thinreports::Errors::DisabledListSection]
      def build_header(values = {}, &block)
        unless format.has_header?
          raise Thinreports::Errors::DisabledListSection.new('header')
        end
        current_page_state.header ||= init_section(:header)
        build_section(header_section, values, &block)
      end

      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def header_section
        current_page_state.header
      end

      # @param (see #build_section)
      # @return [Boolean]
      def add_detail(values = {}, &block)
        return false if current_page_state.finalized?

        successful = true

        if overflow_with?(:detail)
          if auto_page_break?
            change_new_page do |new_list|
              new_list.manager.insert_detail(values, &block)
            end
          else
            finalize
            successful = false
          end
        else
          insert_detail(values, &block)
        end
        successful
      end

      # @param values (see Thinreports::Core::Shape::Manager::Target#values)
      # @yield [section,]
      # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] section
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def insert_detail(values = {}, &block)
        detail = build_section(init_section(:detail), values, &block)
        insert_row(detail)
      end

      # @param [Thinreports::Core::Shape::List::SectionInterface] row
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def insert_row(row)
        row.internal.move_top_to(current_page_state.height)

        current_page_state.rows << row
        current_page_state.height += row.height
        row
      end

      # @param [Thinreports::Core::Shape::List::SectionInterface] section
      # @param values (see Thinreports::Core::Shape::Manager::Target#values)
      # @yield [section,]
      # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] section
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def build_section(section, values = {}, &block)
        section.values(values)
        call_block_in(section, &block)
      end

      # @param [Symbol] section_name
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def init_section(section_name)
        List::SectionInterface.new(current_page,
                                   format.sections[section_name],
                                   section_name)
      end

      # @param [Symbol] section_name
      # @return [Boolean]
      def overflow_with?(section_name = :detail)
        max_height = page_max_height

        if section_name == :footer && format.has_page_footer?
          max_height += format.section_height(:page_footer)
        end

        height = format.section_height(section_name)
        (current_page_state.height + height) > max_height
      end

      # @return [Numeric]
      def page_max_height
        unless @page_max_height
          h  = format.height
          h -= format.section_height(:page_footer)
          h -= format.section_height(:footer) unless auto_page_break?
          @page_max_height = h
        end
        @page_max_height
      end

      # @return [Thinreports::Core::Shape::List::Store]
      def store
        config.store
      end

      # @return [Thinreports::Core::Shape::List::Events]
      def events
        config.internal_events
      end

      # @return [Boolean]
      def auto_page_break?
        format.auto_page_break?
      end

      # @param [Hash] options
      # @option options [Boolean] :ignore_page_footer (false)
      #   When the switch of the page is generated by #finalize, it is used.
      def finalize_page(options = {})
        return if current_page_state.finalized?

        build_header if format.has_header?

        if !options[:ignore_page_footer] && format.has_page_footer?
          page_footer = insert_row(init_section(:page_footer))

          # [DEPRECATION] Use List::Interface#on_page_footer_insert instead.
          events.
            dispatch(List::Events::SectionEvent.new(:page_footer_insert,
                                                    page_footer, store))
          # In 0.8 or later
          @page_footer_handler.call(page_footer) if @page_footer_handler
        end
        current_page_state.finalized!

        # [DEPRECATION] Use List::Interface#on_page_finalize instead.
        events.
          dispatch(List::Events::PageEvent.new(:page_finalize,
                                               current_page,
                                               current_page_state.parent))
        # In 0.8 or later
        @page_finalize_handler.call if @page_finalize_handler

        @page_count += 1
        current_page_state.no = @page_count
      end

      def finalize
        return if finalized?
        finalize_page

        if format.has_footer?
          footer = init_section(:footer)

          # [DEPRECATION] Use List::Interface#on_footer_insert instead.
          events.dispatch(List::Events::SectionEvent.new(:footer_insert, footer, store))

          # In 0.8 or later
          @footer_handler.call(footer) if @footer_handler

          if auto_page_break? && overflow_with?(:footer)
            change_new_page do |new_list|
              new_list.manager.insert_row(footer)
              new_list.manager.finalize_page(ignore_page_footer: true)
            end
          else
            insert_row(footer)
          end
        end
        @finalized = true
      end

      # @return [Boolean]
      def finalized?
        @finalized
      end

      # @return [Thinreports::Report::Base]
      def report
        current_page_state.parent.report
      end

      # @return [Thinreports::Layout::Base]
      def layout
        current_page_state.parent.layout
      end

      # @return [Thinreports::Core::Shape::List::Format]
      def format
        current_page_state.format
      end

      # @return [Thinreports::Core::Shape::List::Configuration]
      def init_config
        layout.config.activate(current_page.id) || List::Configuration.new
      end
    end

  end
end
