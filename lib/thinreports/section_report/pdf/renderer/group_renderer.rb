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

        def render(group)
          pdf.pdf.start_new_page

          group.details.each do |detail|
            section_renderer.render(detail)
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
