# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestFont < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Font = ThinReports::Generator::PDF::Font
  
  def setup
    @doc = ThinReports::Generator::PDF::Document.new
  end
  
  def test_setup_fonts_install_builtin_fonts
    Font::BUILTIN_FONTS.each_key do |font|
      assert_includes @doc.internal.font_families.keys, font
    end
  end
  
  def test_setup_fonts_install_fallback_font
    assert_includes @doc.internal.font_families.keys, 'DefaultFont'
    assert_includes @doc.internal.fallback_fonts, 'DefaultFont'
  end
  
  def test_setup_fonts_install_eudc_fonts
    ThinReports.config.generator.pdf.eudc_fonts = ['eudc1.ttf', 'eudc2.ttf']
    setup
    
    assert_includes @doc.internal.font_families.keys, 'EUDC0'
    assert_includes @doc.internal.font_families.keys, 'EUDC1'
  end
  
  def test_setup_fonts_install_fallback_fonts_as_eudc
    ThinReports.config.generator.pdf.eudc_fonts = 'eudc.ttf'
    setup
    
    assert_includes @doc.internal.fallback_fonts, 'EUDC0'
  end
  
  def test_fallback_font_has_all_styles_as_normal_IPAMincho
    ipam = Font::BUILTIN_FONTS['IPAMincho'][:normal]
    [:normal, :bold, :italic, :bold_italic].each do |style|
       assert_same @doc.internal.font_families['DefaultFont'][style], ipam
    end
  end
  
  def test_setup_fonts_install_alias_fonts_of_CourierNew_and_TimesNewRoman
    assert_same @doc.internal.font_families['Courier New'],
                @doc.internal.font_families['Courier']
    assert_same @doc.internal.font_families['Times New Roman'],
                @doc.internal.font_families['Times-Roman']
  end
  
  def test_default_family
    assert_equal @doc.send(:default_family), 'Helvetica'
  end
  
  def test_default_family_if_missing
    assert_equal @doc.send(:default_family_if_missing, 'unknown font'),
                 @doc.send(:default_family)
    assert_equal @doc.send(:default_family_if_missing, 'IPAMincho'), 'IPAMincho'
  end
  
  def test_font_has_style?
    assert_equal @doc.send(:font_has_style?, 'IPAMincho', :bold), false
    assert_equal @doc.send(:font_has_style?, 'Courier New', :bold), true
  end
end
