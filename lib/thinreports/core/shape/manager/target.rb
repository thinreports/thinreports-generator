# coding: utf-8

module Thinreports
  module Core::Shape

    module Manager::Target
      include Utils

      attr_reader :manager

      # @example
      #   item(:title).value('Title').style(:fill, 'red')
      #
      #   item(:title) do
      #     value('Title')
      #     style(:fill, 'red')
      #   end
      #
      #   item(:title) do |t|
      #     t.value('Title')
      #     t.style(:fill, 'red')
      #   end
      # @param [String, Symbol] id
      # @yield [item,]
      # @yieldparam [Thinreports::Core::Shape::Base::Interface] item
      # @raise [Thinreports::Errors::UnknownItemId] If not found
      # @return [Thinreports::Core::Shape::Base::Interface]
      def item(id, &block)
        shape = find_item(id, except: Core::Shape::List::TYPE_NAME)

        unless shape
          raise Thinreports::Errors::UnknownItemId.new(id)
        else
          call_block_in(shape, &block)
        end
      end

      # @param [Hash] item_values id: value
      def values(item_values)
        item_values.each {|id, val| item(id).value(val)}
      end

      # @param [Symbol, String] id
      # @return [Boolean]
      def item_exists?(id)
        !!manager.find_format(id)
      end
      alias_method :exists?, :item_exists?

      # @see #item
      def list(id = nil, &block)
        shape = find_item(id ||= :default, only: Core::Shape::List::TYPE_NAME)

        unless shape
          raise Thinreports::Errors::UnknownItemId.new(id, 'List')
        else
          manager.lists[id.to_sym] ||= shape
          call_block_in(shape, &block)
        end
      end

    private

      # @param format (see Thinreports::Core::Shape::Manager::Internal#initialize)
      # @yield [format] Handler for initialize item.
      # @yieldparam [Thinreports::Core::Shape::Basic::Format] format
      def initialize_manager(format, &block)
        @manager = Manager::Internal.new(format, block)
      end

      # @see Thinreports::Core::Shape::Manager::Internal#find_item
      def find_item(id, limit = {})
        manager.find_item(id, limit)
      end
    end

  end
end
