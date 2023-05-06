# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Report
      class BlankPage
        # @example
        #   3.times do
        #     page = report.start_new_page
        #     puts page.no
        #   end
        #   # => 1, 2, 3
        # @return [Integer]
        attr_accessor :no

        # @param [Boolean] count (nil)
        def initialize(count = nil)
          @count = count.nil? ? true : count
        end

        # @example
        #   page = report.start_new_page
        #   page.count? # => true
        #
        #   page = report.start_new_page count: false
        #   page.count? # => false
        # @return [Boolean]
        def count?
          @count
        end

        # @return [Boolean] (true)
        def blank?
          true
        end
      end

      class Page < BlankPage
        include Core::Shape::Manager::Target

        # @return [Thinreports::BasicReport::Report::Base]
        attr_reader :report

        # @return [Thinreports::BasicReport::Layout::Base]
        attr_reader :layout

        # @param [Thinreports::BasicReport::Report::Base] report
        # @param [Thinreports::BasicReport::Layout::Base] layout
        # @param [Hash] options ({})
        # @option options [Boolean] :count (true)
        def initialize(report, layout, options = {})
          super(options.key?(:count) ? options[:count] : true)

          @report = report
          @layout = layout
          @finalized = false

          initialize_manager(layout.format) do |f|
            Core::Shape::Interface(self, f)
          end
        end

        # @return [Boolean] (false)
        def blank?
          false
        end

        def copy
          new_page = self.class.new(report, layout, count: count?)

          manager.shapes.each do |id, shape|
            new_shape = shape.copy(new_page)
            new_page.manager.shapes[id] = new_shape

            new_page.manager.lists[id] = new_shape if new_shape.internal.type_of?(Core::Shape::List::TYPE_NAME)
          end
          new_page
        end

        # @param [Hash] options
        # @option options [:create, :copy] :at (:create)
        def finalize(options = {})
          at = options[:at] || :create

          # For list shapes.
          manager.lists.each_value { |list| list.manager.finalize } if at == :create

          @finalized = true
        end

        def finalized?
          @finalized
        end
      end
    end
  end
end
