# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::ImageBlock::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  TEST_IMAGE_BLOCK_FORMAT = {
    "type" => "s-iblock",
    "id" => "image",
    "display" => "true",
    "box" => {
      "x" => 100.0,
      "y" => 100.0,
      "width" => 100.0,
      "height" => 100.0
    },
    "position-x" => "left",
    "position-y" => "top",
    "svg" => {
      "tag" => "image",
      "attrs" => {
        "x" => 100.0,
        "y" => 100.0,
        "width" => 100.0,
        "height" => 100.0
      }
    }
  }
  
  def test_build
    build_format
  rescue => e
    flunk exception_details(e, 'Building failed.')
  end
  
  def test_box_reader_via_TEST_IMAGE_BLOCK_FORMAT
    assert_equal format(TEST_IMAGE_BLOCK_FORMAT).box.values_at('x', 'y', 'width', 'height'),
                 [100.0, 100.0, 100.0, 100.0]
  end
  
  def test_position_x_reader_via_TEST_IMAGE_BLOCK_FORMAT
    assert_equal format(TEST_IMAGE_BLOCK_FORMAT).position_x, 'left'
  end
  
  def test_position_y_reader_via_TEST_IMAGE_BLOCK_FORMAT
    assert_equal format(TEST_IMAGE_BLOCK_FORMAT).position_y, 'top'
  end
  
  def build_format
    ThinReports::Core::Shape::ImageBlock::Format.build(TEST_IMAGE_BLOCK_FORMAT)
  end
  
  def format(data)
    ThinReports::Core::Shape::ImageBlock::Format.new(data)
  end

end