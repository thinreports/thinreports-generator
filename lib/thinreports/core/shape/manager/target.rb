# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Manager
        module Target
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
          #   item(:list)       # => Error: UnknownItemId
          #   item(:unknown_id) # => Error: UnknownItemId
          # @param [String, Symbol] id
          # @yield [item,]
          # @yieldparam [Thinreports::Core::Shape::Base::Interface] item
          # @raise [Thinreports::Errors::UnknownItemId]
          # @return [Thinreports::Core::Shape::Base::Interface]
          def item(id, &block)
            shape = find_item(id, except: Core::Shape::List::TYPE_NAME)

            raise Thinreports::Errors::UnknownItemId, id unless shape

            call_block_in(shape, &block)
          end

          # @example
          #   page[:text_block].style(:bold, true)
          #   page[:rect].style(:border_color, 'red')
          #
          #   page[:list]       # => Error: UnknownItemId
          #   page[:unknown_id] # => Error: UnknownItemId
          # @param [String, Symbol] id
          # @return [Thinreports::Core::Shape::Base::Interface]
          def [](id)
            item(id)
          end

          # @example
          #   page[:text_block]  = 'Title'
          #   page[:image_block] = '/path/to/image.png'
          #   page[:list]        = 'value' # => Error: UnknownItemId
          #   page[:ellipse]     = 'value' # => Error: NoMethodError #value
          #   page[:unknown_id]  = 'value' # => Error: UnknownItemId
          # @param [String, Symbol] id
          # @param [Object] value
          def []=(id, value)
            item(id).value = value
          end

          # @example
          #   page.values text_block: 'value',
          #               image_block: '/path/to/image.png'
          # @param [Hash] item_values
          def values(item_values)
            item_values.each { |id, val| item(id).value(val) }
          end

          # @param [Symbol, String] id
          # @return [Boolean]
          def item_exists?(id)
            !manager.find_format(id).nil?
          end
          alias exists? item_exists?

          # @example
          #   report.list.add_row do |row|
          #     row.item(:price).value(1000)
          #   end
          #
          #   report.list(:list_id) # => List
          #   report.list(:text_block_id) # => raises UnknownItemId
          # @see #item
          def list(id = nil, &block)
            shape = find_item(id ||= :default, only: Core::Shape::List::TYPE_NAME)

            raise Thinreports::Errors::UnknownItemId.new(id, 'List') unless shape

            manager.lists[id.to_sym] ||= shape
            call_block_in(shape, &block)
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
  end
end
