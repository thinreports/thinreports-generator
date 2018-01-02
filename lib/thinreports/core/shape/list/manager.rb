# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class Manager
          include Utils

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

            @finalized = false
            @page_count = 0

            @page_finalize_handler = nil
            @page_footer_handler = nil
            @footer_handler = nil
          end

          # @param [Thinreports::Core::Shape::List::Page] page
          # @return [Thinreports::Core::Shape::List::Manager]
          def switch_current!(page)
            @current_page = page
            @current_page_state = page.internal
            self
          end

          # @yield [new_list]
          # @yieldparam [Thinreports::Core::Shape::List::Page] new_list
          def change_new_page(&block)
            finalize_page
            new_page = report.internal.copy_page

            block.call(new_page.list(current_page.id)) if block_given?
          end

          # @param [Hash] values ({})
          # @yield [header]
          # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] header
          # @return [Thinreports::Core::Shape::List::SectionInterface]
          # @raise [Thinreports::Errors::DisabledListSection]
          def build_header(values = {}, &block)
            raise Thinreports::Errors::DisabledListSection, 'header' unless format.has_header?

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

            max_height += format.section_height(:page_footer) if section_name == :footer && format.has_page_footer?

            height = format.section_height(section_name)
            (current_page_state.height + height) > max_height
          end

          # @return [Numeric]
          def page_max_height
            @page_max_height ||= begin
              h = format.height
              h -= format.section_height(:page_footer)
              h -= format.section_height(:footer) unless auto_page_break?
              h
            end
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

            finalize_page_footer unless options[:ignore_page_footer]

            current_page_state.finalized!
            @page_finalize_handler.call if @page_finalize_handler

            @page_count += 1
            current_page_state.no = @page_count
          end

          def finalize_page_footer
            return unless format.has_page_footer?

            page_footer = init_section(:page_footer)
            insert_row(page_footer)

            @page_footer_handler.call(page_footer) if @page_footer_handler
          end

          def finalize
            return if finalized?
            finalize_page

            if format.has_footer?
              footer = init_section(:footer)

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
        end
      end
    end
  end
end
