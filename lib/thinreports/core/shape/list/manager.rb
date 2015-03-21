# coding: utf-8

module Thinreports
  module Core::Shape

    # @private
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

      # @return [Thinreports::Core::Shape::List::SectionInterface]
      attr_accessor :footer_section

      # @param [Thinreports::Core::Shape::List::Page] page
      def initialize(page)
        switch_current!(page)

        @config = init_config
        @finalized = false
        @page_count = 0
        @footer_section = nil
        @on_page_finalize = nil
      end

      def on_page_finalize(&block)
        if block_given?
          @on_page_finalize = block
        else
          @on_page_finalize
        end
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

      # @see List::Page#header
      def build_header(values = {}, &block)
        unless format.has_header?
          raise Thinreports::Errors::DisabledListSection.new('header')
        end
        current_page_state.header ||= init_section(:header)
        build_section(header_section, values, &block)
      end

      # @see List::Page#page_footer
      def build_page_footer(values = {}, &block)
        unless format.has_page_footer?
          raise Thinreports::Errors::DisabledListSection.new('page footer')
        end
        current_page_state.page_footer ||= init_section(:page_footer)
        build_section(page_footer_section, values, &block)
      end

      # @see List::Page#footer
      def build_footer(values = {}, &block)
        unless format.has_footer?
          raise Thinreports::Errors::DisabledListSection.new('footer')
        end
        @footer_section ||= init_section(:footer)
        build_section(footer_section, values, &block)
      end

      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def header_section
        current_page_state.header
      end

      # @return [Thinreports::Core::Shape::List::SectionInterface]
      def page_footer_section
        current_page_state.page_footer
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
      # @option [Boolean] :ignore_page_footer (false)
      #   When the switch of the page is generated by #finalize, it is used.
      # @private
      def finalize_page(options = {})
        return if current_page_state.finalized?

        build_header if format.has_header?

        if !options[:ignore_page_footer] && format.has_page_footer?
          build_page_footer

          insert_row(page_footer_section)
          # [DEPRECATION] Dispatch page-footer insert event.
          events.
            dispatch(List::Events::SectionEvent.new(:page_footer_insert,
                                                    page_footer_section, store))
        end
        current_page_state.finalized!

        # [DEPRECATION] Dispatch page finalize event.
        # In 0.7 or eariier
        events.
          dispatch(List::Events::PageEvent.new(:page_finalize,
                                               current_page,
                                               current_page_state.parent))
        # In 0.8 or later
        @on_page_finalize.call if @on_page_finalize

        @page_count += 1
        current_page_state.no = @page_count
      end

      # @private
      def finalize
        return if finalized?
        finalize_page

        if format.has_footer?
          build_footer

          # [DEPRECATION] Dispatch footer insert event.
          events.dispatch(List::Events::SectionEvent.new(:footer_insert,
                                                         footer_section, store))

          if auto_page_break? && overflow_with?(:footer)
            change_new_page do |new_list|
              new_list.manager.insert_row(footer_section)
              new_list.manager.finalize_page(ignore_page_footer: true)
            end
          else
            insert_row(footer_section)
          end
        end
        @finalized = true
      end

      # @return [Boolean]
      # @private
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
