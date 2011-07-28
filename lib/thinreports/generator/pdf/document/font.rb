# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module Pdf::Font
      FONT_STORE = File.join(ThinReports::ROOTDIR, 'resources', 'fonts')
      
      BUILTIN_FONTS = {
        'IPAMincho'  => {:normal => File.join(FONT_STORE, 'ipam.ttf')},
        'IPAPMincho' => {:normal => File.join(FONT_STORE, 'ipamp.ttf')},
        'IPAGothic'  => {:normal => File.join(FONT_STORE, 'ipag.ttf')},
        'IPAPGothic' => {:normal => File.join(FONT_STORE, 'ipagp.ttf')}
      }
      
    private
      
      def setup_fonts
        # Install built-in fonts.
        pdf.font_families.update(BUILTIN_FONTS)
        
        # Install fall-back font that IPAMincho.
        fallback_font = BUILTIN_FONTS['IPAMincho'][:normal]
        pdf.font_families['FallbackFont'] = {:normal      => fallback_font,
                                             :bold        => fallback_font,
                                             :italic      => fallback_font,
                                             :bold_italic => fallback_font}
        # Setup fallback font.
        pdf.fallback_fonts(['FallbackFont'])
        
        # Create aliases from the font list provided by Prawn.
        pdf.font_families.update(
          'Courier New'     => pdf.font_families['Courier'],
          'Times New Roman' => pdf.font_families['Times-Roman']
        )
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