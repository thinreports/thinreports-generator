# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Report
      class Group
        attr_reader :headers, :details, :footers

        def initailize(headers, details, footers)
          @headers = headers
          @details = details
          @footers = footers
        end

        def render(pdf)
          Renderer::GroupRenderer.new(pdf, self).render
        end
      end
    end
  end
end
