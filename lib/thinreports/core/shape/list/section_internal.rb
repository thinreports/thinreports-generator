# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class SectionInternal < Base::Internal
          format_delegators :height,
                            :relative_left

          # @return [Symbol]
          attr_accessor :section_name

          def style
            @style ||= Style::Base.new(format)
          end

          # @param [Numeric] ry
          def move_top_to(ry)
            states[:relative_top] = ry
          end

          # @return [Float]
          def relative_top
            states[:relative_top] || 0
          end
        end
      end
    end
  end
end
