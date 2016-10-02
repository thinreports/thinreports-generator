# coding: utf-8

require 'prawn'
require_relative 'prawn_ext'

require_relative 'font'
require_relative 'parse_color'
require_relative 'graphics'
require_relative 'text'
require_relative 'image'
require_relative 'page'

module Thinreports
  module PDF
    class Document
      include Utils

      include Font
      include ParseColor
      include Graphics
      include Text
      include Image
      include Page

      # @return [Prawn::Document]
      attr_reader :pdf

      # @param options (see Thinreports::Generator::PDF#initialize)
      # @param [Hash] metadata
      # @option metadata [String] :Title
      def initialize(options = {}, metadata = {})
        @pdf = Prawn::Document.new(
          skip_page_creation: true,
          margin: [0, 0],
          info: {CreationDate: Time.now,
                      Creator: 'Thinreports Generator for Ruby ' +
                                        Thinreports::VERSION}.merge(metadata)
        )
        # Setup to Prawn::Document.
        setup_fonts
        setup_custom_graphic_states

        # Encrypts the document.
        if options[:security]
          @pdf.encrypt_document(options[:security])
        end
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

      # @see #pdf
      def internal
        @pdf
      end

    private

      def finalize
        clean_temp_images
      end

      # @param [Array<String, Numeric>] values
      # @return [Numeric, Array<Numeric>, nil]
      def s2f(*values)
        return nil if values.empty?

        if values.size == 1
          value = values.first
          return nil unless value
          value.is_a?(::Numeric) ? value : value.to_f
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
