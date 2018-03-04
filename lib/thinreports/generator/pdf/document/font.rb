# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module Font
        FONT_STORE = Thinreports.root.join('fonts')

        BUILTIN_FONTS = {
          'IPAMincho'  => FONT_STORE.join('ipam.ttf').to_s,
          'IPAPMincho' => FONT_STORE.join('ipamp.ttf').to_s,
          'IPAGothic'  => FONT_STORE.join('ipag.ttf').to_s,
          'IPAPGothic' => FONT_STORE.join('ipagp.ttf').to_s
        }.freeze

        DEFAULT_FALLBACK_FONTS = %w[IPAMincho].freeze

        PRAWN_BUINTIN_FONT_ALIASES = {
          'Courier New' => 'Courier',
          'Times New Roman' => 'Times-Roman'
        }.freeze

        def setup_fonts
          # Install built-in fonts.
          BUILTIN_FONTS.each do |font_name, font_path|
            install_font(font_name, font_path)
          end

          # Create aliases from the font list provided by Prawn.
          PRAWN_BUINTIN_FONT_ALIASES.each do |alias_name, name|
            pdf.font_families[alias_name] = pdf.font_families[name]
          end

          # Setup custom fallback fonts
          fallback_fonts = Thinreports.config.fallback_fonts.uniq
          fallback_fonts.map!.with_index do |font, i|
            if pdf.font_families.key?(font)
              font
            else
              install_font "Custom-fallback-font#{i}", font
            end
          end

          # Set fallback fonts
          pdf.fallback_fonts(fallback_fonts + DEFAULT_FALLBACK_FONTS)
        end

        # @param [String] name
        # @param [String] file
        # @return [String] installed font name
        def install_font(name, file)
          raise Errors::FontFileNotFound unless File.exist?(file)

          pdf.font_families[name] = {
            normal: file,
            bold: file,
            italic: file,
            bold_italic: file
          }
          name
        end

        # @return [String]
        def default_family
          'Helvetica'
        end

        # @param [String] family
        # @return [String]
        def default_family_if_missing(family)
          pdf.font_families.key?(family) ? family : default_family
        end

        # @param [String] font_name
        # @param [:bold, :italic] font_style
        # @return [Boolean]
        def font_has_style?(font_name, font_style)
          font = pdf.font_families[font_name]

          return false unless font
          return false unless font.key?(font_style)

          font[font_style] != font[:normal]
        end
      end
    end
  end
end
