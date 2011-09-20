# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestSectionFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  TEST_LIST_SECTION_FORMAT = {
    "height" => 47.7,
    "translate" => {"x" => 0, "y" => -64.2},
    "svg" => {
      "tag" => "g",
      "content" => "<!---SHAPE{\"type\":\"s-tblock\",\"id\":\"t1\"}SHAPE--->" +
                   "<!---SHAPE{\"type\":\"s-rect\",\"id\":\"r1\"}SHAPE--->" +
                   "<!---SHAPE{\"type\":\"s-tblock\",\"id\":\"t2\"}SHAPE--->"
    }
  }
  
  Shape = ThinReports::Core::Shape
  
  def test_build
    shape_format = flexmock(:id => 'mock')
    
    flexmock(Shape::TextBlock::Format).
        should_receive(:build).times(2).and_return(shape_format)
    flexmock(Shape::Basic::Format).
        should_receive(:build).times(1).and_return(shape_format)
    begin
      build_format
    rescue => e
      flunk exception_details(e, 'Building failed.')
    end
  end
  
  def test_config_readers
    format = Shape::List::SectionFormat.new(TEST_LIST_SECTION_FORMAT)
    
    assert_equal format.height, 47.7
    assert_equal format.relative_left, 0
    assert_equal format.relative_top, -64.2
  end
  
  def build_format
    Shape::List::SectionFormat.build(TEST_LIST_SECTION_FORMAT.dup)
  end
end