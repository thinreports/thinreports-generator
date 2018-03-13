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
            install_font(font_name, normal: font_path)
          end

          install_custom_fonts

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
              install_font "Custom-fallback-font#{i}", normal: font
            end
          end

          # Set fallback fonts
          pdf.fallback_fonts(fallback_fonts + DEFAULT_FALLBACK_FONTS)
        end

        # @param [String] name
        # @param [String] normal (required) Path for normal style font
        # @param [String] bold Path for bold style font. Set :normal by default.
        # @param [String] italic Path for italic style font. Set :normal by default.
        # @param [String] bold_italic Path for bold+italic style font. Set :normal by default.
        # @raise [Thinreports::Errors::FontFileNotFound]
        # @return [String] installed font name
        def install_font(name, normal:, bold: normal, italic: normal, bold_italic: normal)
          [normal, bold, italic, bold_italic].uniq.each do |font_file|
            raise Thinreports::Errors::FontFileNotFound, font_file unless File.exist?(font_file)
          end

          pdf.font_families[name] = {
            normal: normal,
            bold: bold,
            italic: italic,
            bold_italic: bold_italic
          }
          name
        end

        def install_custom_fonts
          Thinreports.config.fonts.each do |font_name, font_paths|
            install_font(font_name, **font_paths)
          end
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
