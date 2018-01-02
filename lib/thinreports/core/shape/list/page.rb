# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class Page < Basic::Interface
          extend Forwardable

          attr_reader :manager

          # @param [Thinreports::Report::Page] parent
          # @param [Thinreports::Core::Shape::Basic::Format] format
          # @param [Thinreports::Core::Shape::List::PageState] internal (nil)
          # @param [Thinreports::Core::Shape::List::Manager] manager (nil)
          def initialize(parent, format, internal = nil, manager = nil)
            super(parent, format, internal)

            @manager =
              if manager
                manager.switch_current!(self)
              else
                List::Manager.new(self)
              end

            # Set a reference to List::PageState List::Manager
            self.internal.manager = self.manager
          end

          # @see Thinreports::Core::Shape::List::Manager#build_header
          def_delegator :manager, :build_header, :header

          def on_page_finalize(&block)
            manager.page_finalize_handler = block
          end

          # @yield [page_footer]
          # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] page_footer
          def on_page_footer_insert(&block)
            manager.page_footer_handler = block
          end

          # @yield [footer]
          # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] footer
          # @return [Thinreports::Core::Shape::List::SectionInterface]
          def on_footer_insert(&block)
            manager.footer_handler = block
          end

          # @param [Hash] values ({})
          # @yield [row,]
          # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] row
          # @return [Boolean]
          def add_row(values = {}, &block)
            manager.add_detail(values, &block)
          end

          # If enabled, the auto-page-break of the list will force a page break
          # at the time this method is called. Otherwise, this list will be finalized.
          def page_break
            if manager.auto_page_break?
              manager.change_new_page
            else
              manager.finalize_page
            end
          end
          alias finalize page_break

          # @return [Boolean] Returns true if list has overflowed
          #   when `list#add_row` is called at the next time.
          def overflow?
            manager.overflow_with?(:detail)
          end

          # @param [Thinreports::Report::Page] new_parent
          # @return [Thinreports::Core::Shape::List::Page]
          def copy(new_parent)
            if manager.auto_page_break?
              new_list = self.class.new(new_parent, internal.format,
                                        nil, manager)
            else
              manager.finalize

              new_list = self.class.new(new_parent, internal.format,
                                        internal.copy(new_parent), manager)
              internal.rows.each do |row|
                new_list.internal.rows << row.copy(new_list)
              end
              new_list.internal.finalized!
            end

            new_list.internal.header = internal.header.copy(new_list) if internal.format.has_header?
            new_list
          end

          private

          # @see Thinreports::Core::Shape::Base::Interface#init_internal
          def init_internal(parent, format)
            List::PageState.new(parent, format)
          end
        end

        # Alias to List::Page.
        # @see Thinreports::Core::Shape::List::Page
        List::Interface = List::Page
      end
    end
  end
end
