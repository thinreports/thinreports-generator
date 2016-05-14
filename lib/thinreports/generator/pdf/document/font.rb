# coding: utf-8

module Thinreports
  module Generator

    module PDF::Font
      FONT_STORE = File.join(Thinreports::ROOT, 'fonts')

      BUILTIN_FONTS = {
        'IPAMincho'  => { normal: File.join(FONT_STORE, 'ipam.ttf') },
        'IPAPMincho' => { normal: File.join(FONT_STORE, 'ipamp.ttf') },
        'IPAGothic'  => { normal: File.join(FONT_STORE, 'ipag.ttf') },
        'IPAPGothic' => { normal: File.join(FONT_STORE, 'ipagp.ttf') }
      }

      DEFAULT_FALLBACK_FONTS = %w( Helvetica IPAMincho )

      PRAWN_BUINTIN_FONT_ALIASES = {
        'Courier New' => 'Courier',
        'Times New Roman' => 'Times-Roman'
      }

      def setup_fonts
        # Install built-in fonts.
        pdf.font_families.update(BUILTIN_FONTS)

        # Create aliases from the font list provided by Prawn.
        PRAWN_BUINTIN_FONT_ALIASES.each do |alias_name, name|
          pdf.font_families[alias_name] = pdf.font_families[name]
        end

        # Setup custom fallback fonts
        fallback_fonts = Thinreports.config.fallback_fonts.uniq
        fallback_fonts.map!.with_index do |font, i|
          unless pdf.font_families.key?(font)
            install_font "Custom-fallback-font#{i}", font
          else
            font
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

        pdf.font_families[name] = {normal: file,
                                   bold: file,
                                   italic: file,
                                   bold_italic: file}
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

      # @param [String] font
      # @param [Symbol] style
      # @return [Boolean]
      def font_has_style?(font, style)
        (f = pdf.font_families[font]) && f.key?(style)
      end
    end

  end
end
