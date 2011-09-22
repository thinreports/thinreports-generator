# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module PDF::Page
      
      # @param [ThinReports::Layout::Format] format
      def start_new_page(format)
        format_id = if change_page_format?(format)
          pdf.start_new_page(new_basic_page_options(format))
          @current_page_format = format
          
          unless format_stamp_registry.include?(format.identifier)
            create_format_stamp(format)
          end
          format.identifier
        else
          pdf.start_new_page(new_basic_page_options(current_page_format))
          current_page_format.identifier
        end
        
        stamp(format_id.to_s)
      end
      
      def add_blank_page
        pdf.start_new_page(pdf.page_count.zero? ? {:size => 'A4'} : {})
      end
      
    private
      
      # @return [ThinReports::Layout::Format]
      attr_reader :current_page_format
      
      # @param [ThinReports::Layout::Format] new_format
      # @return [Boolean]
      def change_page_format?(new_format)
        !current_page_format ||
          current_page_format.identifier != new_format.identifier
      end
      
      # @param [ThinReports::Layout::Format] format
      def create_format_stamp(format)
        create_stamp(format.identifier.to_s) do
          parse_svg(format.layout, '/svg/g')
        end
        format_stamp_registry << format.identifier
      end
      
      # @return [Array]
      def format_stamp_registry
        @format_stamp_registry ||= []
      end
      
      # @param [ThinReports::Layout::Format] format
      # @return [Hash]
      def new_basic_page_options(format)
        options = {:layout => format.page_orientation.to_sym}
        options[:size] = if format.user_paper_type?
          [format.page_width.to_f, format.page_height.to_f]
        else
          format.page_paper_type
        end
        options
      end
    end
    
  end
end