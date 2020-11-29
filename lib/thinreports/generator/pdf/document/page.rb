# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module Page
        JIS_SIZES = {
          'B4' => [728.5, 1031.8],
          'B5' => [515.9, 728.5]
        }.freeze

        # @param [Thinreports::Layout::Format] format
        def start_new_page(format)
          format_id =
            if change_page_format?(format)
              pdf.start_new_page(new_basic_page_options(format))
              @current_page_format = format

              create_format_stamp(format) unless format_stamp_registry.include?(format.identifier)
              format.identifier
            else
              pdf.start_new_page(new_basic_page_options(current_page_format))
              current_page_format.identifier
            end

          stamp(format_id.to_s)
        end

        def start_new_page_for_section_report(format)
          @current_page_format = format
          pdf.start_new_page(new_basic_page_options(current_page_format).merge(
            top_margin: current_page_format.page_margin[0],
            bottom_margin: current_page_format.page_margin[2]
          ))
        end

        def max_content_height
          pdf.margin_box.height
        end

        def add_blank_page
          pdf.start_new_page(pdf.page_count.zero? ? { size: 'A4' } : {})
        end

        private

        # @return [Thinreports::Layout::Format]
        attr_reader :current_page_format

        # @param [Thinreports::Layout::Format] new_format
        # @return [Boolean]
        def change_page_format?(new_format)
          !current_page_format ||
            current_page_format.identifier != new_format.identifier
        end

        # @param [Thinreports::Layout::Format] format
        def create_format_stamp(format)
          create_stamp(format.identifier.to_s) do
            draw_template_items(format.attributes['items'])
          end
          format_stamp_registry << format.identifier
        end

        # @return [Array]
        def format_stamp_registry
          @format_stamp_registry ||= []
        end

        # @param [Thinreports::Layout::Format] format
        # @return [Hash]
        def new_basic_page_options(format)
          options = { layout: format.page_orientation.to_sym }

          options[:size] =
            if format.user_paper_type?
              [format.page_width.to_f, format.page_height.to_f]
            else
              case format.page_paper_type
              # Convert B4(5)_ISO to B4(5)
              when 'B4_ISO', 'B5_ISO'
                format.page_paper_type.delete('_ISO')
              when 'B4', 'B5'
                JIS_SIZES[format.page_paper_type]
              else
                format.page_paper_type
              end
            end
          options
        end
      end
    end
  end
end
