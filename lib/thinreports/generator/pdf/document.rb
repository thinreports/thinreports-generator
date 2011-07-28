# coding: utf-8

require 'thinreports/generator/pdf/document/font'
require 'thinreports/generator/pdf/document/parse_color'
require 'thinreports/generator/pdf/document/graphics'
require 'thinreports/generator/pdf/document/draw_shape'
require 'thinreports/generator/pdf/document/parse_svg'

module ThinReports
  module Generator
    
    # @private
    class Pdf::Document
      include Pdf::Font
      include Pdf::ParseColor
      include Pdf::Graphics
      include Pdf::DrawShape
      include Pdf::ParseSVG
      
      # @param options (see ThinReports::Generator::Pdf#initialize)
      def initialize(options = {})
        @pdf = Prawn::Document.new(
          :skip_page_creation => true,
          :margin => [0, 0],
          :info   => {:Creator => 'ThinReports Generator for Ruby ' +
                                  ThinReports::VERSION}
        )
        @format_stamp_registry = []
        
        # Setup to Prawn::Document.
        setup_fonts
        setup_custom_graphic_states
        
        # Encrypts the document.
        if options[:security]
          @pdf.encrypt_document(options[:security])
        end
      end
      
      # @param [ThinReports::Layout::Format] format (nil)
      def start_new_page(format = nil)
        options   = {}
        format_id = format.identifier
        
        if format
          options[:layout] = format.page_orientation.to_sym
          options[:size]   = if format.user_paper_type?
            [format.page_width.to_f, format.page_height.to_f]
          else
            format.page_paper_type
          end
        end
        
        pdf.start_new_page(options)
        
        # @note
        #   The best way is to create a template for each layout.
        #   However, in the latest Prawn library, because of problems handling
        #   the template that you want supported by future releases.
        # @see https://github.com/sandal/prawn/issues/199
        unless format_stamp_registry.include?(format_id)
          create_format_stamp(format)
        end
        # Apply the static shapes of current format.
        stamp(format_id.to_s)
      end
      
      def add_blank_page
        pdf.start_new_page(pdf.page_count.zero? ? {:size => 'A4'} : {})
      end
      
      # Delegate to Prawn::Document#render
      # @see Prawn::Document#render
      def render
        result = pdf.render
        finalize
        result
      end
      
      # Delegate to Prawn::Document#render_file
      # @see Prawn::Document#render_file
      def render_file(*args)
        finalize
        pdf.render_file(*args)
      end
      
      # @param [Numeric, String] x
      # @param [Numeric, String] y
      def translate(x, y, &block)
        x, y = rpos(x, y)
        pdf.translate(x, y, &block)
      end
      
      # @param [String] stamp_id
      # @param [Array<Numeric>] at (nil)
      def stamp(stamp_id, at = nil)
        unless at.nil?
          pdf.stamp_at(stamp_id, rpos(*at))
        else
          pdf.stamp(stamp_id)
        end
      end
      
      # Delegate to Prawn::Document#create_stamp
      # @param [String] id
      # @see Prawn::Document#create_stamp
      def create_stamp(id, &block)
        pdf.create_stamp(id, &block)
      end
      
      # @private
      # @see #pdf
      def internal
        @pdf
      end
      
    private
      
      # @return [Prawn::Document]
      attr_reader :pdf
      
      # @return [Array<Symbol>]
      attr_reader :format_stamp_registry
      
      def finalize
        clean_temp_images
      end
      
      # @param [ThinReports::Layout::Format] format
      def create_format_stamp(format)
        create_stamp(format.identifier.to_s) do
          parse_svg(format.layout, '/svg/g')
        end
        format_stamp_registry << format.identifier
      end      
      
      # @param [Array<String, Numeric>] values
      # @return [Numeric, Array<Numeric>, nil]
      def s2f(*values)
        return nil if values.empty?
        
        if values.size == 1
          if value = values.first
            value.is_a?(::Numeric) ? value : value.to_f
          end
        else
          values.map {|v| s2f(v) }
        end
      end
      
      # @param [Numeric, String] x
      # @param [Numeric, String] y
      # @return [Array<Float>]
      def map_to_upper_left_relative_position(x, y)
        x, y = s2f(x, y)
        [x, -y]
      end
      alias_method :rpos, :map_to_upper_left_relative_position
      
      # @param [Numeric, String] x
      # @param [Numeric, String] y
      # @return [Array<Float>]
      def map_to_upper_left_position(x, y)
        x, y = s2f(x, y)
        [x, pdf.bounds.height - y]
      end
      alias_method :pos, :map_to_upper_left_position
    end
    
  end
end
