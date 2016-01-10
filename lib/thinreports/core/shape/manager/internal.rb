# coding: utf-8

module Thinreports
  module Core::Shape

    class Manager::Internal
      include Utils

      attr_reader :format
      attr_reader :shapes
      attr_reader :lists

      # @param [Thinreports::Core::Manager::Format] format
      # @param [Proc] init_item_handler
      def initialize(format, init_item_handler)
        @format = format
        @shapes = {}
        @lists  = {}
        @init_item_handler = init_item_handler
      end

      # @param [String, Symbol] id
      # @return [Thinreports::Core::Shape::Basic::Format]
      def find_format(id)
        format.find_shape(id.to_sym)
      end

      # @param [String, Symbol] id
      # @param limit (see #valid_type?)
      def find_item(id, limit = {})
        id = id.to_sym
        case
        when shape = shapes[id]
          return nil unless valid_type?(shape.type, limit)
          shape
        when sformat = find_format(id)
          return nil unless valid_type?(sformat.type, limit)
          shapes[id] = init_item(sformat)
        else
          return nil
        end
      end

      # @param [String, Symbol] id
      # @return [Thinreports::Core::Shape::Base::Interface, nil]
      def final_shape(id)
        shape = shapes[id]

        # When shape was found in registry.
        if shape
          return nil unless shape.visible?

          # In the case of TextBlock or ImageBlock.
          if shape.internal.type_of?(:block)
            blank_value?(shape.internal.real_value) ? nil : shape
          else
            shape
          end
        # When shape was not found in registry.
      elsif format.has_shape?(id)
          shape_format = find_format(id)
          return nil unless shape_format.display?

          case shape_format.type
          # In the case of TextBlock.
          when TextBlock::TYPE_NAME
            shape_format.has_reference? || !blank_value?(shape_format.value) ? init_item(shape_format) : nil
          # In the case of ImageBlock, Return the nil constantly.
          when ImageBlock::TYPE_NAME
            nil
          else
            init_item(shape_format)
          end
        # In the case of other, Return the nil constantly.
        else
          nil
        end
      end

      # @param [Thinreports::Core::Shape::Basic::Format] format
      def init_item(format)
        @init_item_handler.call(format)
      end

      # @param [String] type
      # @param [Hash] limit
      # @option limit [String] :only
      # @option limit [String] :except
      # @return [Booldan]
      def valid_type?(type, limit = {})
        return true if limit.empty?
        case
        when only = limit[:only]
          type == only
        when except = limit[:except]
          type != except
        else
          raise ArgumentError
        end
      end
    end

  end
end
