# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        class Format < Basic::Format
          attr_reader :rows

          def initialize(*)
            super
            initialize_rows
          end

          private

          def initialize_rows
            @rows = []
            attributes['rows'].each do |row|
              @rows << StackView::RowFormat.new(row)
            end
          end
        end
      end
    end
  end
end
