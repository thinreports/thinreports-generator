# frozen_string_literal: true

require_relative 'section_renderer'

module Thinreports
  module SectionReport
    module Renderer
      class GroupRenderer
        def initialize(pdf)
          @pdf = pdf
          @section_renderer = Renderer::SectionRenderer.new(pdf)
        end

        def render(report, group)
          pdf.start_new_page_for_section_report report.schema
          current_page_height = 0

          max_page_height = pdf.max_content_height

          group.headers.each do |header|
            section_renderer.render(header)
            current_page_height += section_renderer.section_height(header)
          end

          group.details.each do |detail|
            if current_page_height + section_renderer.section_height(detail) > max_page_height
              pdf.start_new_page_for_section_report report.schema
              current_page_height = 0

              group.headers.each do |header|
                if header.schema.every_page?
                  section_renderer.render(header)
                  current_page_height += section_renderer.section_height(header)
                end
              end
            end
            section_renderer.render(detail)
            current_page_height += section_renderer.section_height(detail)
          end

          group.footers.each do |footer|
            if current_page_height + section_renderer.section_height(footer) > max_page_height
              pdf.start_new_page_for_section_report report.schema
              current_page_height = 0
            end
            section_renderer.render(footer)
            current_page_height += section_renderer.section_height(footer)
          end
        end

        private

        attr_reader :pdf, :section_renderer
      end
    end
  end
end
