# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Pdf
      module Stroke
        STROKE_BASE_WIDTH = 0.9

        attr_accessor :stroke_color, :stroke_width
                      :stroke_dash_length, :stroke_dash_space

        def initialize(*)
          super
          @stroke_color = 'none'
          @stroke_width = 0
          @stroke_dash_length = 0
          @stroke_dash_space = 0
        end

        def stroke? = stroke_width.positive? && stroke_color != 'none'

        def stroke_dash?
          stroke? && stroke_dash_length.positive?
        end

        def stroke_width
          super * BASE_WIDTH
        end

        def stroke_style=(type)
          @stroke_dash_length, @stroke_dash_space =
            case type
            when 'dashed' then [2, 2]
            when 'dotted' then [1, 2]
            else [0, 0]
            end
        end
      end
    end
  end
end
