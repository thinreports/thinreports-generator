# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module TextBlock
        class Format < Basic::BlockFormat
          # For saving compatible 0.8.x format API
          config_reader ref_id: %w[reference-id]
          config_reader valign: %w[style vertical-align]
          config_reader overflow: %w[style overflow]
          config_reader line_height: %w[style line-height]

          config_reader format_base: %w[format base],
                        format_type: %w[format type],
                        format_datetime_format: %w[format datetime format],
                        format_number_delimiter: %w[format number delimiter],
                        format_number_precision: %w[format number precision],
                        format_padding_char: %w[format padding char],
                        format_padding_dir: %w[format padding direction]

          config_checker true, multiple: %w[multiple-line]
          config_checker 'R', format_padding_rdir: %w[format padding direction]

          config_reader format_padding_length: %w[format padding length] do |len|
            blank_value?(len) ? 0 : len.to_i
          end

          config_reader has_format?: %w[format type] do |type|
            %w[datetime number padding].include?(type)
          end

          # For saving compatible 0.8.x format API
          def has_reference?
            !blank_value?(ref_id)
          end
        end
      end
    end
  end
end
