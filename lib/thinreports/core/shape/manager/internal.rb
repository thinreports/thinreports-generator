# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Manager
        class Internal
          include Utils

          attr_reader :format
          attr_reader :shapes
          attr_reader :lists

          # @param [Thinreports::Core::Manager::Format] format
          # @param [Proc] init_item_handler
          def initialize(format, init_item_handler)
            @format = format
            @shapes = {}
            @lists = {}
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

            if shapes.key?(id)
              shape = shapes[id]
              valid_type?(shape.type, limit) ? shape : nil
            elsif find_format(id)
              shape_format = find_format(id)
              return nil unless valid_type?(shape_format.type, limit)

              shape = init_item(shape_format)
              shapes[id] = shape

              shape
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
                return nil if !shape_format.has_reference? && blank_value?(shape_format.value)
                init_item(shape_format)
              # In the case of ImageBlock, Return the nil constantly.
              when ImageBlock::TYPE_NAME
                nil
              else
                init_item(shape_format)
              end
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

            if limit[:only]
              type == limit[:only]
            elsif limit[:except]
              type != limit[:except]
            else
              raise ArgumentError
            end
          end
        end
      end
    end
  end
end
