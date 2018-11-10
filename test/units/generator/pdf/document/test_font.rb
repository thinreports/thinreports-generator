# frozen_string_literal: true

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

    Font::BUILTIN_FONTS.each do |name, path|
      expected_font = {
        normal: path,
        bold: path,
        italic: path,
        bold_italic: path
      }
      assert_equal expected_font, pdf.font_families[name]
    end

    Font::PRAWN_BUINTIN_FONT_ALIASES.each do |alias_font, original_font|
      assert_equal pdf.font_families[alias_font],
                   pdf.font_families[original_font]
    end

    assert_equal Font::DEFAULT_FALLBACK_FONTS, %w[IPAMincho]
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

  def test_default_family
    assert_equal 'Helvetica', document.default_family
  end

  def test_default_family_if_mmissing
    assert_equal 'Helvetica', document.default_family_if_missing('unknown')
    assert_equal 'IPAMincho', document.default_family_if_missing('IPAMincho')
  end

  def test_font_has_style?
    doc = create_document

    assert_equal false, doc.font_has_style?('unknown', :bold)

    doc.pdf.font_families['font_foo'] = {
      normal: '/path/to/foo.ttf'
    }
    assert_equal false, doc.font_has_style?('font_foo', :italic)

    doc.pdf.font_families['font_foo'] = {
      normal: '/path/to/foo.ttf',
      bold: '/path/to/foo.ttf'
    }
    assert_equal false, doc.font_has_style?('font_foo', :bold)

    doc.pdf.font_families['font_foo'] = {
      normal: '/path/to/foo.ttf',
      bold: '/path/to/foo_bold.ttf'
    }
    assert_equal true, doc.font_has_style?('font_foo', :bold)
  end

  def document
    Thinreports::Generator::PDF::Document.new
  end
  alias_method :create_document, :document
end
