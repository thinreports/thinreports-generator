# frozen_string_literal: true

require_relative 'section_renderer'

module Thinreports
  module SectionReport
    module Renderer
      class GroupRenderer
        def initialize(pdf, group)
          @pdf = pdf
          @group = group
        end

        def render
          render_headers
          render_details
          render_footers
        end

        private

        attr_reader :pdf, :group

        def render_headers(headers = group.headers)
          headers.each { |header| header.render(pdf) }
        end

        def render_details
          group.details.each do |detail|
            if pdf.page_overflow_with?(detail.height(pdf))
              pdf.start_new_page
              render_headers(every_page_headers)
            end

            detail.render(pdf)
          end
        end

        def render_footers
          group.footers.each do |footer|
            pdf.start_new_page if pdf.page_overflow_with?(footer.height(pdf))

            footer.render(pdf)
          end
        end

        def every_page_headers
          @every_page_headers ||= group.headers.select { |header|
            header.schema.every_page?
          }
        end
      end
    end
  end
end
