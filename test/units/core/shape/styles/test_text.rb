# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Style::TestText < Minitest::Test
  include Thinreports::TestHelper

  def test_color
    style = create_text_style('color' => 'red')
    assert_equal 'red', style.color

    style.color = 'blue'
    assert_equal 'blue', style.styles['color']
    assert_equal 'blue', style.color
  end

  def test_font_size
    style = create_text_style('font-size' => 18.0)
    assert_equal 18.0, style.font_size

    style.font_size = 19
    assert_equal 19, style.styles['font-size']
    assert_equal 19, style.font_size
  end

  def test_initialize_font_style
    default_font_style = ['bold', 'italic']
    style = create_text_style('font-style' => default_font_style)

    refute_same default_font_style, style.styles['font-style']
    assert_equal default_font_style, style.styles['font-style']
  end

  def test_bold
    style = create_text_style('font-style' => ['bold'])
    assert_equal true, style.bold

    style.bold = false
    assert_equal [], style.styles['font-style']
    assert_equal false, style.bold
  end

  def test_italic
    style = create_text_style('font-style' => ['italic'])
    assert_equal true, style.italic

    style.italic = false
    assert_equal [], style.styles['font-style']
    assert_equal false, style.italic
  end

  def test_underline
    style = create_text_style('font-style' => ['underline'])
    assert_equal true, style.underline

    style.underline = false
    assert_equal [], style.styles['font-style']
    assert_equal false, style.underline
  end

  def test_linethrough
    style = create_text_style('font-style' => ['linethrough'])
    assert_equal true, style.linethrough

    style.linethrough = false
    assert_equal [], style.styles['font-style']
    assert_equal false, style.linethrough
  end

  def test_align
    style = create_text_style('text-align' => 'center')
    assert_equal :center, style.align

    style.align = :right
    assert_equal 'right', style.styles['text-align']
    assert_equal :right, style.align
  end

  def test_valign
    style = create_text_style('vertical-align' => '')
    assert_equal :top, style.valign

    style.valign = :middle
    assert_equal 'middle', style.styles['vertical-align']
    assert_equal :middle, style.valign

    assert_deprecated { style.valign = :center }
    assert_equal :middle, style.valign
  end

  private

  def create_text_style(default_style = {})
    format = Thinreports::Core::Shape::Text::Format.new('style' => default_style)
    Thinreports::Core::Shape::Style::Text.new(format)
  end
end
