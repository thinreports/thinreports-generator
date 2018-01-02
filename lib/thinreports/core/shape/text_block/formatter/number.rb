# frozen_string_literal: true

require 'bigdecimal'

module Thinreports
  module Core
    module Shape
      module TextBlock
        module Formatter
          class Number < Formatter::Basic
            private

            def apply_format_to(value)
              precision = format.format_number_precision
              delimiter = format.format_number_delimiter

              if_applicable value do |val|
                val = number_with_precision(val, precision) unless blank_value?(precision)
                val = number_with_delimiter(val, delimiter) unless blank_value?(delimiter)
                val
              end
            end

            def if_applicable(value, &block)
              normalized_value = normalize(value)
              normalized_value.nil? ? value : block.call(normalized_value)
            end

            def normalize(value)
              if value.is_a?(String)
                convert_to_integer(value) || convert_to_float(value)
              else
                value
              end
            end

            def number_with_delimiter(value, delimiter = ',')
              value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/) { "#{$1}#{delimiter}" }
            end

            def number_with_precision(value, precision = 3)
              value = BigDecimal(value.to_s).round(precision)
              sprintf("%.#{precision}f", value)
            end

            def convert_to_integer(value)
              Integer(value)
            rescue ArgumentError
              nil
            end

            def convert_to_float(value)
              Float(value)
            rescue ArgumentError
              nil
            end
          end
        end
      end
    end
  end
end
