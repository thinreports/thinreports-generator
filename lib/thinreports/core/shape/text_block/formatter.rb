module Thinreports
  module Core::Shape::TextBlock

    module Formatter
      # @param [Thinreports::Core::Shape::TextBlock::Format] format
      # @return [Thinreports::Core::Shape::TextBlock::Formatter::Base]
      def self.setup(format)
        klass =
          if Thinreports.blank_value?(format.format_type)
            Basic
          else
            case format.format_type
            when 'number'   then Number
            when 'datetime' then Datetime
            when 'padding'  then Padding
            else
              raise Thinreports::Errors::UnknownFormatterType
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
