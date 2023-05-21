# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Pdf
      module Fill
        attr_accessor :fill_color

        def initialize(*)
          super
          @fill_color = 'none'
        end

        def fill?
          fill_color && fill_color != 'none'
        end
      end
    end
  end
end
