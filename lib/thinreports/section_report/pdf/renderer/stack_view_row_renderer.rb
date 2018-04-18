require_relative 'stack_view_renderer'
require_relative 'content_height'
require_relative 'draw_item'

module Thinreports
  module SectionReport
    module Renderer
      class StackViewRowRenderer
        include ContentHeight
        include DrawItem

        def initialize(pdf)
          @pdf = pdf
        end

        def render(row)
          doc = pdf.pdf

          actual_height = content_height(row)
          doc.bounding_box([0, doc.cursor], width: doc.bounds.width, height: actual_height) do
            row.items.each do |item|
              draw_item(item, (actual_height - row.schema.height))
            end
            # doc.stroke_bounds
          end

          # bounding_box 実行完了後、doc.cursorの位置はbox末尾に移動する
          # https://github.com/prawnpdf/prawn/blob/master/lib/prawn/document/bounding_box.rb#L44
        end

        private

        attr_reader :pdf

        def stack_view_renderer
          @stack_view_renderer ||= Renderer::StackViewRenderer.new(pdf)
        end
      end
    end
  end
end
