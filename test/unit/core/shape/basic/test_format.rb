# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  TEST_BASIC_FORMAT = {
    "type" => "s-rect",
    "id" => "rect_1",
    "display" => "true",
    "svg" => {
      "tag" => "rect",
      "attrs" => {
        "stroke" => "#000000",
        "stroke-width" => "1",
        "fill" => "#ff0000",
        "fill-opacity" => "1",
        "stroke-dasharray" => "none",
        "rx" => "0",
        "ry" => "0",
        "width" => "196.1",
        "height" => "135.1",
        "x" => "85",
        "y" => "82"
      }
    }
  }

  # Alias
  Format = ThinReports::Core::Shape::Basic::Format

  def test_build_basic_format
    build_basic_format
  rescue => e
    flunk exception_details(e, 'Building failed.')
  end
  
  def test_basic_config_readers
    format = Format.new(TEST_BASIC_FORMAT)
    
    assert_equal format.id, 'rect_1'
    assert_equal format.type, 's-rect'
    assert_equal format.svg_tag, 'rect'
    assert_equal format.display?, true
    assert_equal format.svg_attrs['stroke'], '#000000'
    assert_equal format.svg_attrs['stroke-dasharray'], 'none'
  end
  
  def test_display?
    format = Format.new('display' => 'false')
    
    assert_equal format.display?, false
  end
  
  def build_basic_format
    Format.build(TEST_BASIC_FORMAT)
  end
end