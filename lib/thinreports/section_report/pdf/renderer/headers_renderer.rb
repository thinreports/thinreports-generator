# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Renderer
      class HeadersRenderer
        def initialize(pdf)
          @pdf = pdf
          @section_renderer = Renderer::SectionRenderer.new(pdf)
        end

        def render(headers)
          headers.each do |header|
            section_renderer.render(header)
          end
        end

        private

        attr_reader :pdf, :section_renderer
      end
    end
  end
end
