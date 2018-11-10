# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::Graphics::TestBasic < Minitest::Test
  include Thinreports::TestHelper

  def setup
    @pdf = Thinreports::Generator::PDF::Document.new
  end

  def test_build_stroke_styles
    style = {
      stroke: 'red',
      stroke_width: 2.0,
      stroke_type: 'solid'
    }

    assert_equal(
      {
        color: 'ff0000',
        width: 2.0,
        dash: nil
      },
      @pdf.build_stroke_styles(style)
    )

    style_stroke_dashed = style.merge(stroke_type: 'dashed')
    assert_equal [2, 2], @pdf.build_stroke_styles(style_stroke_dashed)[:dash]

    style_stroke_dotted = style.merge(stroke_type: 'dotted')
    assert_equal [1, 2], @pdf.build_stroke_styles(style_stroke_dotted)[:dash]

    assert_nil @pdf.build_stroke_styles(stroke: nil, stroke_width: 1)
    assert_nil @pdf.build_stroke_styles(stroke: 'none', stroke_width: 1)

    assert_nil @pdf.build_stroke_styles(stroke_width: nil, stroke: 'red')
    assert_nil @pdf.build_stroke_styles(stroke_width: 0, stroke: 'red')
  end

  def test_build_fill_styles
    assert_equal({ color: 'ff0000' }, @pdf.build_fill_styles(fill: 'red'))
    assert_nil @pdf.build_fill_styles(fill: nil)
    assert_nil @pdf.build_fill_styles(fill: 'none')
  end
end
