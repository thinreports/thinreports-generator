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
                unless blank_value?(precision)
                  val = number_with_precision(val, precision)
                end
                unless blank_value?(delimiter)
                  val = number_with_delimiter(val, delimiter)
                end
                val
              end
            end

            def if_applicable(value, &block)
              normalized_value = normalize(value)
              normalized_value.nil? ? value : block.call(normalized_value)
            end

            def normalize(value)
              if value.is_a?(String)
                # rubocop:disable Style/RescueModifier
                (Integer(value) rescue nil) || (Float(value) rescue nil)
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
          end
        end
      end
    end
  end
end
