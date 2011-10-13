# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Style::TestGraphic < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_graphic_style
    format = ThinReports::Core::Shape::Basic::Format.new({})
    ThinReports::Core::Shape::Style::Graphic.new(format)
  end
  
  def test_border_color_should_properly_set_to_internal_styles_as_stroke_style
    style = create_graphic_style
    style.border_color = '#ff0000'
    
    assert_equal style.styles['stroke'], '#ff0000'
  end
  
  def test_border_width_should_properly_set_to_internal_styles_as_stroke_width_style
    style = create_graphic_style
    style.border_width = 1
    
    assert_equal style.styles['stroke-width'], 1
  end
  
  def test_border_width_should_set_stroke_opacity_to_1_when_width_is_not_zero
    style = create_graphic_style
    style.border_width = 5
    
    assert_equal style.styles['stroke-opacity'], '1'
  end
  
  def test_fill_color_should_properly_set_to_internal_styles_as_fill_style
    style = create_graphic_style
    style.fill_color = '#0000ff'
    
    assert_equal style.styles['fill'], '#0000ff'
  end
  
  def test_fill_should_operate_like_the_fill_color_method
    style = create_graphic_style
    style.fill = '#ff0000'
    
    assert_same style.fill_color, style.fill
  end
  
  def test_stroke_should_operate_like_the_border_width_method
    style = create_graphic_style
    style.stroke = 5
    
    assert_same style.border_width, style.stroke
  end
  
  def test_border_should_return_an_Array_included_border_width_and_border_color
    style = create_graphic_style
    style.border_width = 1
    style.border_color = '#ff0000'
    
    assert_equal style.border, [style.border_width, style.border_color]
  end
  
  def test_border_should_properly_set_both_border_width_and_border_color_from_the_specified_array_argument
    style = create_graphic_style
    style.border = [5, '#000000']
    
    assert_equal style.border, [5, '#000000']
  end
end