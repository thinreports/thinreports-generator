require_relative 'section_renderer'

module Thinreports
  module SectionReport
    module Renderer
      class GroupRenderer
        # Page = Struct.new :content_height

        def initialize(pdf)
          @pdf = pdf
          @section_renderer = Renderer::SectionRenderer.new(pdf)
        end

        def render(report, group)
          doc = pdf.pdf

          max_page_height = doc.bounds.height - report.schema.page_margin_top - report.schema.page_margin_bottom


          doc.start_new_page
          doc.move_down report.schema.page_margin_top
          current_page_height = 0

          group.headers.each do |header|
            section_renderer.render(header)
            current_page_height += section_renderer.content_height(header)
          end

          group.details.each do |detail|
            if current_page_height + section_renderer.content_height(detail) > max_page_height
              doc.start_new_page
              doc.move_down report.schema.page_margin_top
              current_page_height = 0

              group.headers.each do |header|
                if header.schema.every_page?
                  section_renderer.render(header)
                  current_page_height += section_renderer.content_height(header)
                end
              end
            end
            section_renderer.render(detail)
            current_page_height += section_renderer.content_height(detail)
          end

          group.footers.each do |footer|
            section_renderer.render(footer)
          end
        end

        private

        attr_reader :pdf, :section_renderer
        #
        # def setup_new_page
        #   pdf.start_new_page
        #
        #   @page_count += 1
        #
        #   group.headers.each do |header|
        #     section_renderer.render(header) if header.schema.every_page? || @page_count == 1
        #   end
        #
        #   group.footers.each { |header| section_renderer.render(header) }
        # end
      end
    end
  end
end
