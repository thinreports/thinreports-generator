# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module PDF::Font
      FONT_STORE = File.join(ThinReports::ROOTDIR, 'resources', 'fonts')
      
      BUILTIN_FONTS = {
        'IPAMincho'  => {:normal => File.join(FONT_STORE, 'ipam.ttf')},
        'IPAPMincho' => {:normal => File.join(FONT_STORE, 'ipamp.ttf')},
        'IPAGothic'  => {:normal => File.join(FONT_STORE, 'ipag.ttf')},
        'IPAPGothic' => {:normal => File.join(FONT_STORE, 'ipagp.ttf')}
      }

      PRAWN_BUINTIN_FONT_ARIASES = {
        'Courier New' => 'Courier',
        'Times New Roman' => 'Times-Roman'
      }

      # Register alias font name to Prawn::Font::AFM::BUILT_INS.
      # This is for <font name="font-name"> inline format.
      PRAWN_BUINTIN_FONT_ARIASES.keys.each do |alias_name|
        Prawn::Font::AFM::BUILT_INS << alias_name
      end

    private
      
      def setup_fonts
        # Install built-in fonts.
        pdf.font_families.update(BUILTIN_FONTS)
        
        fallback_fonts = []
        
        # Install EUDC fonts.
        ThinReports.config.generator.pdf.eudc_fonts.each_with_index do |eudc, i|
          eudc_name = "EUDC#{i}"
          install_font_family(eudc_name, eudc)
          fallback_fonts << eudc_name
        end
        
        # Install fall-back font(default font) that IPAMincho.
        install_font_family('DefaultFont', BUILTIN_FONTS['IPAMincho'][:normal])
        fallback_fonts << 'DefaultFont'
        
        # Setup fallback fonts.
        pdf.fallback_fonts(fallback_fonts)
        
        # Create aliases from the font list provided by Prawn.
        PRAWN_BUINTIN_FONT_ARIASES.each do |new_name, old_name|
          pdf.font_families[new_name] = pdf.font_families[old_name]
        end
      end
      
      # @param [String] name
      # @param [String] file
      def install_font_family(name, file)
        pdf.font_families[name] = {:normal      => file,
                                   :bold        => file,
                                   :italic      => file,
                                   :bold_italic => file}
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
