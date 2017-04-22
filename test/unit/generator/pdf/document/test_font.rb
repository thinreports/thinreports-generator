require 'test_helper'

class Thinreports::Generator::PDF::TestFont < Minitest::Test
  include Thinreports::TestHelper

  Font = Thinreports::Generator::PDF::Font

  def teardown
    # Reset font settings
    Thinreports.configure do |c|
      c.fallback_fonts = []
    end
  end

  def test_setup_fonts
    pdf = document.pdf

    Font::BUILTIN_FONTS.each do |name, font|
      assert_equal font, pdf.font_families[name]
    end

    Font::PRAWN_BUINTIN_FONT_ALIASES.each do |alias_font, original_font|
      assert_equal pdf.font_families[alias_font],
                   pdf.font_families[original_font]
    end

    assert_equal Font::DEFAULT_FALLBACK_FONTS, pdf.fallback_fonts[-2..-1]
  end

  def test_setup_fonts_with_custom_fallback_fonts
    Thinreports.configure do |c|
      c.fallback_fonts = []
    end
    assert_equal Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    Thinreports.configure do |c|
      c.fallback_fonts = 'IPAGothic'
    end
    assert_equal ['IPAGothic'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    Thinreports.configure do |c|
      c.fallback_fonts = ['IPAMincho']
    end
    assert_equal ['IPAMincho'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts

    Thinreports.configure do |c|
      c.fallback_fonts = ['IPAMincho', data_file('font.ttf')]
    end
    assert_equal ['IPAMincho', 'Custom-fallback-font1'] + Font::DEFAULT_FALLBACK_FONTS,
                 document.pdf.fallback_fonts
  end

  def test_setup_fonts_with_unknown_custom_fallback_fonts
    Thinreports.configure do |c|
      c.fallback_fonts = ['/path/to/unknown.ttf']
    end

    assert_raises Thinreports::Errors::FontFileNotFound do
      create_document
    end
  end

  def test_font_helpers
    doc = document

    assert_equal 'Helvetica', doc.default_family

    assert_equal 'Helvetica', doc.default_family_if_missing('unknown')
    assert_equal 'IPAMincho', doc.default_family_if_missing('IPAMincho')

    assert_equal false, doc.font_has_style?('IPAMincho', :bold)
    assert_equal true, doc.font_has_style?('Courier New', :bold)
  end

  def document
    Thinreports::Generator::PDF::Document.new
  end
  alias_method :create_document, :document
end
