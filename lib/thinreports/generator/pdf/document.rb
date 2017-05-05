# frozen_string_literal: true

require_relative 'document/font'
require_relative 'document/parse_color'
require_relative 'document/graphics'
require_relative 'document/draw_shape'
require_relative 'document/draw_template_items'
require_relative 'document/page'

module Thinreports
  module Generator
    class PDF
      class Document
        include Utils

        include PDF::Font
        include PDF::ParseColor
        include PDF::Graphics
        include PDF::DrawShape
        include PDF::DrawTemplateItems
        include PDF::Page

        # @return [Prawn::Document]
        attr_reader :pdf

        # @param [String] title (nil)
        # @param [Hash] security (nil)
        def initialize(title: nil, security: nil)
          @pdf = Prawn::Document.new(
            skip_page_creation: true,
            margin: [0, 0],
            info: {
              CreationDate: Time.now,
              Creator: 'Thinreports Generator for Ruby ' + Thinreports::VERSION,
              Title: title
            }
          )
          # Setup to Prawn::Document.
          setup_fonts
          setup_custom_graphic_states

          # Encrypts the document.
          @pdf.encrypt_document(security) if security
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
          if at.nil?
            pdf.stamp(stamp_id)
          else
            pdf.stamp_at(stamp_id, rpos(*at))
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
            values.map { |v| s2f(v) }
          end
        end

        # @param [Numeric, String] x
        # @param [Numeric, String] y
        # @return [Array<Float>]
        def map_to_upper_left_relative_position(x, y)
          x, y = s2f(x, y)
          [x, -y]
        end
        alias rpos map_to_upper_left_relative_position

        # @param [Numeric, String] x
        # @param [Numeric, String] y
        # @return [Array<Float>]
        def map_to_upper_left_position(x, y)
          x, y = s2f(x, y)
          [x, pdf.bounds.height - y]
        end
        alias pos map_to_upper_left_position
      end
    end
  end
end
