# coding: utf-8

module ThinReports
  module Core::Shape::TextBlock
    
    # @private
    module Formatter
      # @param [ThinReports::Core::Shape::TextBlock::Format] format
      # @return [ThinReports::Core::Shape::TextBlock::Formatter::Base]
      def self.setup(format)
        klass = if format.format_type.blank?
          Basic
        else
          case format.format_type
          when 'number'   then Number
          when 'datetime' then Datetime
          when 'padding'  then Padding
          else
            raise ThinReports::Errors::UnknownFormatterType
          end
        end
        klass.new(format)
      end
    end
    
  end
end

require 'thinreports/core/shape/text_block/formatter/basic'
require 'thinreports/core/shape/text_block/formatter/datetime'
require 'thinreports/core/shape/text_block/formatter/padding'
require 'thinreports/core/shape/text_block/formatter/number'
