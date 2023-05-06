# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Core
      module Shape
        module TextBlock
          module Formatter
            include Utils

            # @param [Thinreports::BasicReport::Core::Shape::TextBlock::Format] format
            # @return [Thinreports::BasicReport::Core::Shape::TextBlock::Formatter::Base]
            def self.setup(format)
              klass =
                if blank_value?(format.format_type)
                  Basic
                else
                  case format.format_type
                  when 'number'   then Number
                  when 'datetime' then Datetime
                  when 'padding'  then Padding
                  else
                    raise Thinreports::BasicReport::Errors::UnknownFormatterType
                  end
                end
              klass.new(format)
            end
          end
        end
      end
    end
  end
end

require_relative 'formatter/basic'
require_relative 'formatter/datetime'
require_relative 'formatter/padding'
require_relative 'formatter/number'
