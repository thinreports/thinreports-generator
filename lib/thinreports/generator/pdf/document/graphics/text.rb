# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module Graphics
        # @param [String] content
        # @param [Numeric, String] x
        # @param [Numeric, String] y
        # @param [Numeric, String] w
        # @param [Numeric, String] h
        # @param [Hash] attrs ({})
        # @option attrs [String] :font
        # @option attrs [Numeric, String] :size
        # @option attrs [String] :color
        # @option attrs [Array<:bold, :italic, :underline, :strikethrough>]
        #   :styles (nil)
        # @option attrs [:left, :center, :right] :align (:left)
        # @option attrs [:top, :center, :bottom] :valign (:top)
        # @option attrs [Numeric, String] :line_height The total height of an text line.
        # @option attrs [Numeric, String] :letter_spacing
        # @option attrs [Boolean] :single (false)
        # @option attrs [:trancate, :shrink_to_fit, :expand] :overflow (:trancate)
        # @option attrs [:none, :break_word] :word_wrap (:none)
        # @raise [Thinreports::Errors::UnknownFont] When :font can't be found in built-in fonts and registerd fonts
        def text_box(content, x, y, w, h, attrs = {})

          return if attrs[:color] == 'none'

          # Building parameters for box
          box_params = build_box_params(x, y, w, h, attrs)
          # Building parameters for text
          text_params = build_text_params(content, attrs)

          if need_bold_style_emulation?(text_params[:font], text_params[:styles])
            box_params[:mode] = :fill_stroke

            emulate_bold_style(text_params[:color], text_params[:size]) do
              pdf.formatted_text_box([text_params], box_params)
            end
          else
            pdf.formatted_text_box([text_params], box_params)
          end
        rescue Prawn::Errors::UnknownFont => e
          raise Thinreports::Errors::UnknownFont, e
        rescue Prawn::Errors::CannotFit
          # Nothing to do.
          #
          # When the area is too small compared
          # with the content and the style of the text.
          #   (See prawn/core/text/formatted/line_wrap.rb#L185)
        end

        # @see #text_box
        def text(content, x, y, w, h, attrs = {})
          # Set the :overflow property to :shirink_to_fit.
          text_box(content, x, y, w, h, { overflow: :shirink_to_fit }.merge(attrs))
        end

        # @private
        #
        # @param (see #text_box)
        # @return [Hash] Returns first parameter (Formatted Text Array) of Prawn::Document#formatted_text_box
        #   See http://prawnpdf.org/api-docs/2.0/Prawn/Text/Formatted.html
        def build_box_params(x, y, w, h, attrs)
          w, h = s2f(w, h)

          {}.tap do |params|
            params[:at] = pos(x, y)
            params[:width] = w

            [
              :align,
              :valign,
              :overflow
            ].each { |param_key| params[param_key] = attrs[param_key] }

            if attrs[:single]
              params[:single_line] = attrs[:overflow] != :expand
            else
              params[:height] = h
            end

            if attrs[:line_height]
              params[:leading] = text_line_leading(attrs[:line_height], name: attrs[:font], size: attrs[:size])
            end

            if attrs[:letter_spacing]
              params[:character_spacing] = attrs[:letter_spacing]
            end
          end
        end

        # @private
        #
        # @param (see #text_box)
        # @return [Hash] Returns second parameter (Options) of Prawn::Document#formatted_text_box
        #   See http://prawnpdf.org/api-docs/2.0/Prawn/Text.html#text_box-instance_method
        def build_text_params(content, attrs)
          {}.tap do |params|
            params[:text] = attrs[:word_wrap] == :none ? text_without_line_wrap(content) : content
            params[:styles] = attrs[:styles] || []
            params[:size] = attrs[:size]
            params[:font] = attrs[:font]
            params[:color] = parse_color(attrs[:color])
          end
        end

        # @private
        #
        # @param [Numeric] line_height
        # @param [Hash] font
        # @option font [String] :name Name of font.
        # @option font [Numeric] :size Size of font.
        # @return [Numeric]
        def text_line_leading(line_height, font)
          line_height - pdf.font(font[:name], size: font[:size]).height
        end

        # @private
        #
        # @param [String] content
        # @return [String]
        def text_without_line_wrap(content)
          content.gsub(/ /, Prawn::Text::NBSP)
        end

        # @private
        #
        # @param [String] font_family
        # @param [Array<Symbol>] font_styles
        # @return [Boolean]
        def need_bold_style_emulation?(font_family, font_styles)
          font_styles.include?(:bold) && !font_has_style?(font_family, :bold)
        end

        # @private
        #
        # @param [String] font_color
        # @param [Integer, Float] font_size
        def emulate_bold_style(font_color, font_size, &block)
          save_graphics_state

          pdf.stroke_color(font_color)
          pdf.line_width(font_size * 0.025)

          yield

          restore_graphics_state
        end
      end
    end
  end
end
