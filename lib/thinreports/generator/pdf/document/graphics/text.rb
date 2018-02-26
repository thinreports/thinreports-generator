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
        def text_box(content, x, y, w, h, attrs = {}, &block)
          w, h = s2f(w, h)

          box_attrs = text_box_attrs(
            x, y, w, h,
            single: attrs.delete(:single),
            overflow: attrs[:overflow]
          )

          # Do not break by word unless :word_wrap is :break_word
          content = text_without_line_wrap(content) if attrs[:word_wrap] == :none

          with_text_styles(attrs) do |built_attrs, font_styles|
            if block
              block.call [{ text: content, styles: font_styles }],
                built_attrs.merge(box_attrs)
            else
              pdf.formatted_text_box(
                [{ text: content, styles: font_styles }],
                built_attrs.merge(box_attrs)
              )
            end
          end
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

        private

        # @param x (see #text_box)
        # @param y (see #text_box)
        # @param w (see #text_box)
        # @param h (see #text_box)
        # @param [Hash] states
        # @option states [Boolean] :single
        # @option states [Symbold] :overflow
        # @return [Hash]
        def text_box_attrs(x, y, w, h, states = {})
          attrs = {
            at: pos(x, y),
            width: s2f(w)
          }
          if states[:single]
            states[:overflow] != :expand ? attrs.merge(single_line: true) : attrs
          else
            attrs.merge(height: s2f(h))
          end
        end

        # @param attrs (see #text)
        # @yield [built_attrs, font_styles]
        # @yieldparam [Hash] built_attrs The finalized attributes.
        # @yieldparam [Array] font_styles The finalized styles.
        def with_text_styles(attrs, &block)
          # When no color is given, do not draw.
          return unless attrs.key?(:color) && attrs[:color] != 'none'

          save_graphics_state

          fontinfo = {
            name: attrs.delete(:font).to_s,
            color: parse_color(attrs.delete(:color)),
            size: s2f(attrs.delete(:size))
          }

          # Add the specified value to :leading option.
          line_height = attrs.delete(:line_height)
          if line_height
            attrs[:leading] = text_line_leading(
              s2f(line_height),
              name: fontinfo[:name],
              size: fontinfo[:size]
            )
          end

          # Set the :character_spacing option.
          spacing = attrs.delete(:letter_spacing)
          attrs[:character_spacing] = s2f(spacing) if spacing

          # Or... with_font_styles(attrs, fontinfo, &block)
          with_font_styles(attrs, fontinfo) do |modified_attrs, styles|
            block.call(modified_attrs, styles)
          end

          restore_graphics_state
        end

        # @param [Numeric] line_height
        # @param [Hash] font
        # @option font [String] :name Name of font.
        # @option font [Numeric] :size Size of font.
        # @return [Numeric]
        def text_line_leading(line_height, font)
          line_height - pdf.font(font[:name], size: font[:size]).height
        end

        # @param [String] content
        # @return [String]
        def text_without_line_wrap(content)
          content.gsub(/ /, Prawn::Text::NBSP)
        end

        # @param [Hash] attrs
        # @param [Hash] font
        # @option font [String] :color
        # @option font [Numeric] :size
        # @option font [String] :name
        # @yield [attributes, styles]
        # @yieldparam [Hash] modified_attrs
        # @yieldparam [Array] styles
        def with_font_styles(attrs, font, &block)
          # Building font styles.
          styles = attrs.delete(:styles)

          if styles
            manual, styles = styles.partition do |style|
              %i[bold italic].include?(style) && !font_has_style?(font[:name], style)
            end
          end

          # Emulate bold style.
          if manual && manual.include?(:bold)
            pdf.stroke_color(font[:color])
            pdf.line_width(font[:size] * 0.025)

            # Change rendering mode to :fill_stroke.
            attrs[:mode] = :fill_stroke
          end

          # Emulate italic style.
          if manual && manual.include?(:italic)
            # FIXME
            # pdf.transformation_matrix(1, 0, 0.26, 1, 0, 0)
          end

          pdf.font(font[:name], size: font[:size]) do
            pdf.fill_color(font[:color])
            block.call(attrs, styles || [])
          end
        end
      end
    end
  end
end
