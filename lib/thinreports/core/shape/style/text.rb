# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Style
        class Text < Style::Basic
          style_accessible :bold, :italic, :underline, :linethrough,
                           :align, :valign, :color, :font_size

          # @method color
          #   @return [String]
          # @method color=(v)
          #   @param [String] v
          style_accessor :color, 'color'

          # @method font_size
          #   @return [Numeric, String]
          # @method font_size=(v)
          #   @param [Numeric, String] v
          style_accessor :font_size, 'font-size'

          def initialize(*)
            super
            initialize_font_style
          end

          # @return [Boolean]
          def bold
            read_internal_style('font-style').include?('bold')
          end

          # @param [Boolean] enable
          def bold=(enable)
            write_font_style('bold', enable)
          end

          # @return [Boolean]
          def italic
            read_internal_style('font-style').include?('italic')
          end

          # @param [Boolean] enable
          def italic=(enable)
            write_font_style('italic', enable)
          end

          # @return [Boolean]
          def underline
            read_internal_style('font-style').include?('underline')
          end

          # @param [Boolean] enable
          def underline=(enable)
            write_font_style('underline', enable)
          end

          # @return [Boolean]
          def linethrough
            read_internal_style('font-style').include?('linethrough')
          end

          # @param [Boolean] enable
          def linethrough=(enable)
            write_font_style('linethrough', enable)
          end

          # @return [:left, :center, :right]
          def align
            read_internal_style('text-align').to_sym
          end

          # @param [:left, :center, :right] align_name
          def align=(align_name)
            verify_style_value(align_name, %i[left center right],
                               'Only :left or :center, :right can be specified as align.')
            write_internal_style('text-align', align_name.to_s)
          end

          # @return [:top, :middle, :bottom]
          def valign
            vertical_align = read_internal_style('vertical-align')
            blank_value?(vertical_align) ? :top : vertical_align.to_sym
          end

          # @param [:top, :center, :middle, :bottom] valign_name
          def valign=(valign_name)
            if valign_name == :center
              warn '[DEPRECATION] :center value for valign style is deprecated' \
                   ' and will be removed in thinreports-generator 1.0.' \
                   ' Please use :middle instead of :center.'
              valign_name = :middle
            end

            verify_style_value(
              valign_name,
              %i[top middle bottom],
              'Only :top or :middle (:center), :bottom can be specified as valign.'
            )
            write_internal_style('vertical-align', valign_name.to_s)
          end

          private

          def initialize_font_style
            styles['font-style'] ||= (@base_styles['font-style'] || []).dup
          end

          def write_font_style(style_name, enable)
            if enable
              styles['font-style'].push(style_name).uniq!
            else
              styles['font-style'].delete(style_name)
            end
          end
        end
      end
    end
  end
end
