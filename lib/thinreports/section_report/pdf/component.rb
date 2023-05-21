# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Pdf
      module Component
        def point(x, y)
          [x, pdf.bounds.height - y]
        end
      end
    end
  end
end
