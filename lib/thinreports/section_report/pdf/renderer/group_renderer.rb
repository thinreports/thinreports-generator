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
          @page_count = 0


          page_footers_size = 0
          group.footers.each do |footer|
            page_footers_size += footer.schema.height if footer.schema.every_page?
          end
          max_page_height = doc.bounds.height - report.schema.page_margin_top - report.schema.page_margin_bottom - page_footers_size


          doc.start_new_page
          doc.move_down report.schema.page_margin_top
          @page_count += 1
          current_page_height = 0

          group.headers.each do |header|
            if header.schema.every_page? || @page_count == 1
              section_renderer.render(header)
              current_page_height += header.schema.height
            end
          end

          group.details.each do |detail|
            if current_page_height + detail.schema.height > max_page_height
              group.footers.each do |footer|
                section_renderer.render(footer) if footer.schema.every_page? && !footer.schema.fixed_bottom?
              end

              group.footers.each do |footer|
                doc.move_cursor_to report.schema.page_margin_bottom + footer.schema.height
                section_renderer.render(footer) if footer.schema.every_page? && footer.schema.fixed_bottom?
              end

              doc.start_new_page
              doc.move_down report.schema.page_margin_top
              @page_count += 1
              current_page_height = 0

              group.headers.each do |header|
                if header.schema.every_page? || @page_count == 1
                  section_renderer.render(header)
                  current_page_height += header.schema.height
                end
              end
            end
            section_renderer.render(detail)
            current_page_height += detail.schema.height
          end

          group.footers.each do |footer|
            section_renderer.render(footer) if !footer.schema.fixed_bottom?
          end

          group.footers.each do |footer|
            doc.move_cursor_to report.schema.page_margin_bottom + footer.schema.height
            section_renderer.render(footer) if footer.schema.fixed_bottom?
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
