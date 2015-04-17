# coding: utf-8

module Thinreports
  module Core

    module Shape
      def Interface(parent, format)
        find_by_type(format.type)::Interface.new(parent, format)
      end

      def Format(type)
        find_by_type(type)::Format
      end

      def Configuration(type)
        klass = find_by_type(type)
        unless klass.const_defined?(:Configuration)
          raise Thinreports::Errors::NoConfigurationFound, type
        end
        klass.const_get(:Configuration)
      end

      module_function :Interface, :Format, :Configuration

      def self.find_by_type(type)
        case type
        when TextBlock::TYPE_NAME  then TextBlock
        when ImageBlock::TYPE_NAME then ImageBlock
        when List::TYPE_NAME       then List
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

require 'thinreports/core/shape/style'
require 'thinreports/core/shape/manager'
require 'thinreports/core/shape/base'
require 'thinreports/core/shape/basic'
require 'thinreports/core/shape/text'
require 'thinreports/core/shape/text_block'
require 'thinreports/core/shape/image_block'
require 'thinreports/core/shape/list'
require 'thinreports/core/shape/page_number'
