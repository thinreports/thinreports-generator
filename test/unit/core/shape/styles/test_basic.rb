# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Style::TestBasic < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_basic_style(format_config = {})
    format = ThinReports::Core::Shape::Basic::Format.new(format_config)
    ThinReports::Core::Shape::Style::Basic.new(format)
  end
  
  def test_visible_should_return_visibility_of_format_as_default
    style = create_basic_style('display' => 'false')
    assert_equal style.visible, false
  end
  
  def test_visible_should_properly_set_visibility
    style = create_basic_style('display' => 'false')
    style.visible = true
    
    assert_equal style.visible, true
  end
end