# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestSectionInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def setup
    parent = flexmock('parent')
    format = flexmock(:height        => 100,
                      :relative_left => 100,
                      :relative_top  => 200,
                      :svg_tag       => 'g')
    @internal = List::SectionInternal.new(parent, format)
  end
  
  def test_move_top_to
    @internal.move_top_to(100)
    assert_equal @internal.states[:relative_top], 100
  end
  
  def test_relative_position
    assert_equal @internal.relative_position, [100, 200]
    @internal.move_top_to(50)
    assert_equal @internal.relative_position, [100, 250]
  end
end