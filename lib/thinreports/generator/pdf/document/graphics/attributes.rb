# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module Graphics
        # @param [Hash] style
        # @yield [attrs]
        # @yieldparam [Hash] attrs
        # @return [Hash]
        def build_graphic_attributes(style, &block)
          graphic_attributes = {
            stroke: style['border-color'],
            stroke_width: style['border-width'],
            stroke_type: style['border-style'],
            fill: style['fill-color']
          }
          block.call(graphic_attributes) if block_given?
          graphic_attributes
        end

        # @param [Hash] style
        # @yield [attrs]
        # @yieldparam [Hash] attrs
        # @return [Hash]
        def build_text_attributes(style, &block)
          text_attributes = {
            font: font_family(style['font-family']),
            size: style['font-size'],
            color: style['color'],
            align: text_align(style['text-align']),
            valign: text_valign(style['vertical-align']),
            styles: font_styles(style['font-style']),
            letter_spacing: letter_spacing(style['letter-spacing']),
            line_height: line_height(style['line-height']),
            overflow: text_overflow(style['overflow']),
            word_wrap: word_wrap(style['word-wrap'])
          }
          block.call(text_attributes) if block_given?
          text_attributes
        end

        # @param [Array<String>] font_names
        # @return [String]
        def font_family(font_names)
          font_name = font_names.first
          default_family_if_missing(font_name)
        end

        # @param [Array<String>] styles
        # @return [Array<Symbol>]
        def font_styles(styles)
          styles.map do |font_style|
            case font_style
            when 'bold' then :bold
            when 'italic' then :italic
            when 'underline' then :underline
            when 'linethrough' then :strikethrough
            end
          end
        end

        # @param [Float, "", nil] spacing
        # @return [Float, nil]
        def letter_spacing(spacing)
          blank_value?(spacing) ? nil : spacing
        end

        # @param ["left", "center", "right", ""] align
        # @return [:left, :center, :right]
        def text_align(align)
          case align
          when 'left' then :left
          when 'center' then :center
          when 'right' then :right
          when '' then :left
          else :left
          end
        end

        # @param ["top", "middle", "bottom", "", nil] valign
        # @return [:top, :center, :bottom]
        def text_valign(valign)
          case valign
          when 'top' then :top
          when 'middle' then :center
          when 'bottom' then :bottom
          when '' then :top
          else :top
          end
        end

        # @param ["truncate", "fit", "expand", "", nil] overflow
        # @return [:truncate, :shrink_to_fit, :expand]
        def text_overflow(overflow)
          case overflow
          when 'truncate' then :truncate
          when 'fit' then :shrink_to_fit
          when 'expand' then :expand
          when '' then :truncate
          else :truncate
          end
        end

        # @param ["break-word", "none", "", nil] word_wrap
        # @return [:break_word, :none]
        def word_wrap(word_wrap)
          case word_wrap
          when 'break-word' then :break_word
          when 'none' then :none
          else :none
          end
        end

        # @param [Float, "", nil] height
        # @return [Float, nil]
        def line_height(height)
          blank_value?(height) ? nil : height
        end

        # @param ["left", "center", "right", ""] position
        # @return [:left, :center, :right]
        def image_position_x(position)
          case position
          when 'left' then :left
          when 'center' then :center
          when 'right' then :right
          when '' then :left
          else :left
          end
        end

        # @param ["top", "middle", "bottom", ""] position
        # @return [:left, :center, :right]
        def image_position_y(position)
          case position
          when 'top' then :top
          when 'middle' then :center
          when 'bottom' then :bottom
          when '' then :top
          else :top
          end
        end
      end
    end
  end
end
