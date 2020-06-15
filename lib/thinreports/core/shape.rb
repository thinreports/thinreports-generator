# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      def Interface(parent, format)
        find_by_type(format.type)::Interface.new(parent, format)
      end

      def Format(type)
        find_by_type(type)::Format
      end

      module_function :Interface, :Format

      def self.find_by_type(type)
        case type
        when TextBlock::TYPE_NAME  then TextBlock
        when ImageBlock::TYPE_NAME then ImageBlock
        when List::TYPE_NAME       then List
        when StackView::TYPE_NAME  then StackView
        when Text::TYPE_NAME       then Text
        when PageNumber::TYPE_NAME then PageNumber
        when *Basic::TYPE_NAMES    then Basic
        else
          raise Thinreports::Errors::UnknownShapeType
        end
      end
    end
  end
end

require_relative 'shape/style'
require_relative 'shape/manager'
require_relative 'shape/base'
require_relative 'shape/basic'
require_relative 'shape/text'
require_relative 'shape/text_block'
require_relative 'shape/image_block'
require_relative 'shape/list'
require_relative 'shape/stack_view'
require_relative 'shape/page_number'
