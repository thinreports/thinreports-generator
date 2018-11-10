# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::Graphics::TestAttributes < Minitest::Test
  include Thinreports::TestHelper

  def setup
    @pdf = Thinreports::Generator::PDF::Document.new
  end

  def test_build_graphic_attributes
    graphic_styles = {
      'border-color' => '#ff0000',
      'border-width' => 2.0,
      'border-style' => 'solid',
      'fill-color' => '#000000'
    }

    assert_equal(
      {
        stroke: '#ff0000',
        stroke_width: 2.0,
        stroke_type: 'solid',
        fill: '#000000'
      },
      @pdf.build_graphic_attributes(graphic_styles)
    )

    customized_attributes = @pdf.build_graphic_attributes(graphic_styles) { |attrs| attrs[:stroke] = 'blue' }
    assert_equal 'blue', customized_attributes[:stroke]
  end

  def test_build_text_attributes
    text_styles = {
      'font-family' => %w( Helvetica IPAMincho ),
      'font-size' => 18.0,
      'color' => 'red',
      'text-align' => 'right',
      'vertical-align' => 'bottom',
      'font-style' => %w( bold italic ),
      'letter-spacing' => 2.0,
      'line-height' => 20.0,
      'overflow' => 'expand',
      'word-wrap' => 'break-word'
    }

    assert_equal(
      {
        font: 'Helvetica',
        size: 18.0,
        color: 'red',
        align: :right,
        valign: :bottom,
        styles: [:bold, :italic],
        letter_spacing: 2.0,
        line_height: 20.0,
        overflow: :expand,
        word_wrap: :break_word
      },
      @pdf.build_text_attributes(text_styles)
    )

    customized_attributes = @pdf.build_text_attributes(text_styles) { |attrs| attrs[:color] = 'blue' }
    assert_equal 'blue', customized_attributes[:color]
  end

  def test_font_family
    assert_equal 'IPAGothic', @pdf.font_family(%w( IPAGothic Helvetica ))
    assert_equal 'Helvetica', @pdf.font_family(%w( Unknown IPAMincho ))
  end

  def test_font_styles
    assert_equal [:bold, :italic, :underline, :strikethrough],
      @pdf.font_styles(%w( bold italic underline linethrough ))
  end

  def test_letter_spacing
    assert_equal 2.0, @pdf.letter_spacing(2.0)
    assert_nil @pdf.letter_spacing('')
    assert_nil @pdf.letter_spacing(nil)
  end

  def test_text_align
    assert_equal :left, @pdf.text_align('left')
    assert_equal :center, @pdf.text_align('center')
    assert_equal :right, @pdf.text_align('right')
    assert_equal :left, @pdf.text_align('')
    assert_equal :left, @pdf.text_align(nil)
  end

  def test_text_valign
    assert_equal :top, @pdf.text_valign('top')
    assert_equal :center, @pdf.text_valign('middle')
    assert_equal :bottom, @pdf.text_valign('bottom')
    assert_equal :top, @pdf.text_valign('')
    assert_equal :top, @pdf.text_valign(nil)
  end

  def test_text_overflow
    assert_equal :truncate, @pdf.text_overflow('truncate')
    assert_equal :shrink_to_fit, @pdf.text_overflow('fit')
    assert_equal :expand, @pdf.text_overflow('expand')
    assert_equal :truncate, @pdf.text_overflow('')
    assert_equal :truncate, @pdf.text_overflow(nil)
  end

  def test_word_wrap
    assert_equal :break_word, @pdf.word_wrap('break-word')
    assert_equal :none, @pdf.word_wrap('none')
    assert_equal :none, @pdf.word_wrap(nil)
  end

  def test_line_height
    assert_equal 20.9, @pdf.line_height(20.9)
    assert_nil @pdf.line_height('')
    assert_nil @pdf.line_height(nil)
  end

  def test_image_position_x
    assert_equal :left, @pdf.image_position_x('left')
    assert_equal :center, @pdf.image_position_x('center')
    assert_equal :right, @pdf.image_position_x('right')
    assert_equal :left, @pdf.image_position_x('')
    assert_equal :left, @pdf.image_position_x(nil)
  end

  def test_image_position_y
    assert_equal :top, @pdf.image_position_y('top')
    assert_equal :center, @pdf.image_position_y('middle')
    assert_equal :bottom, @pdf.image_position_y('bottom')
    assert_equal :top, @pdf.image_position_y('')
    assert_equal :top, @pdf.image_position_y(nil)
  end
end
