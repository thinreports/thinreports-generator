# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module PageNumber
        class Format < Basic::Format
          config_reader :target
          config_reader default_format: %w[format]

          # For saving compatible 0.8.x format API
          config_reader overflow: %w[style overflow]

          def id
            @id ||= blank_value?(read('id')) ? self.class.next_default_id : read('id')
          end

          def for_report?
            blank_value?(target)
          end

          def self.next_default_id
            @id_counter ||= 0
            "__pageno#{@id_counter += 1}"
          end
        end
      end
    end
  end
end
