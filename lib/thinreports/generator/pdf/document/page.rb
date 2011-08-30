# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module Pdf::Page
      
      # @param [ThinReports::Layout::Format] format
      def start_new_page(format)
        if change_page_format?(format)
          @current_page_format = format
        else
          format = nil
        end
        
        if ThinReports.config.generator.pdf.manage_templates?
          prepare_new_page_with_template(format)
        else
          prepare_new_page_with_stamp(format)
        end
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
      
      # @param [ThinReports::Layout::Format, nil] format
      def prepare_new_page_with_template(format = nil)
        if format
          template_file = format_template_file(format)
          unless File.exists?(template_file)
            create_format_template(format, template_file)
          else
            File.utime(Time.now, Time.now, template_file)
          end
          pdf.start_new_page(:template => template_file)
        else
          pdf.start_new_page(:template => format_template_file(current_page_format))
        end
      end
      
      # @param [ThinReports::Layout::Format, nil] format
      def prepare_new_page_with_stamp(format = nil)
        pdf.start_new_page(new_basic_page_options(format || current_page_format))
        
        format_id = if format
          unless format_stamp_registry.include?(format.identifier)
            create_format_stamp(format)
          end
          format.identifier
        else
          current_page_format.identifier
        end
        
        stamp(format_id.to_s)
      end
      
      # @param [ThinReports::Layout::Format] format
      # @param [String] template
      def create_format_template(format, template)
        temp = self.class.new
        temp.internal.start_new_page(new_basic_page_options(format))
        temp.parse_svg(format.layout, '/svg/g')
        temp.render_file(template)
        temp = nil
      end
      
      # @param [ThinReports::Layout::Format] format
      def create_format_stamp(format)
        create_stamp(format.identifier.to_s) do
          parse_svg(format.layout, '/svg/g')
        end
        format_stamp_registry << format.identifier
      end
      
      # @param [ThinReports::Layout::Format] format
      # @return [String]
      def format_template_file(format)
        @format_templates_store ||= ThinReports.config.generator.pdf.manage_templates
        File.join(@format_templates_store, "#{format.identifier}.pdf")
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