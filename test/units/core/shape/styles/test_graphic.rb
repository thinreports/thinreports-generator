# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Style::TestGraphic < Minitest::Test
  include Thinreports::TestHelper

  def test_border_color
    style = create_graphic_style('border-color' => 'red')
    assert_equal 'red', style.border_color

    style.border_color = '#ff0000'
    assert_equal '#ff0000', style.styles['border-color']
    assert_equal '#ff0000', style.border_color
  end

  def test_border_width
    style = create_graphic_style('border-width' => 2.0)
    assert_equal 2.0, style.border_width

    style.border_width = 10.9
    assert_equal 10.9, style.styles['border-width']
    assert_equal 10.9, style.border_width
  end

  def test_fill_color
    style = create_graphic_style('fill-color' => '#0000ff')
    assert_equal '#0000ff', style.fill_color

    style.fill_color = 'blue'
    assert_equal 'blue', style.styles['fill-color']
    assert_equal 'blue', style.fill_color
  end

  def test_border
    style = create_graphic_style('border-color' => 'red', 'border-width' => 1)
    assert_equal [1, 'red'], style.border

    style.border = [2.0, '#ff0000']
    assert_equal 2.0, style.styles['border-width']
    assert_equal '#ff0000', style.styles['border-color']
  end

  private

  def create_graphic_style(default_style = {})
    format = Thinreports::Core::Shape::Basic::Format.new('style' => default_style)
    Thinreports::Core::Shape::Style::Graphic.new(format)
  end
end
