# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestSectionInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def create_internal(format_config = {})
    List::SectionInternal.new(flexmock('parent'),
                              List::SectionFormat.new(format_config))
  end
  
  def test_height_should_operate_as_delegator_of_format
    list = create_internal('height' => 100)
    assert_same list.height, list.format.height
  end
  
  def test_relative_left_should_operate_as_delegator_of_format
    list = create_internal('translate' => {'x' => 10})
    assert_same list.relative_left, list.format.relative_left
  end
  
  def test_relative_top_should_operate_as_delegator_of_format
    list = create_internal('translate' => {'y' => 10})
    assert_same list.relative_top, list.format.relative_top
  end
  
  def test_svg_tag_should_operate_as_delegator_of_format
    list = create_internal('svg' => {'tag' => 'g'})
    assert_same list.svg_tag, list.format.svg_tag
  end
    
  def test_move_top_to_should_properly_set_value_to_states_as_relative_top
    list = create_internal
    list.move_top_to(200)
    
    assert_equal list.states[:relative_top], 200
  end
  
  def test_relative_position_should_return_Array_included_coordinates
    list = create_internal('translate' => {'x' => 100, 'y' => 200})
    
    assert_equal list.relative_position, [100, 200]
  end
  
  def test_Y_coordinate_which_relative_position_returns_should_be_calculated_position_with_relative_top_of_states
    list = create_internal('translate' => {'x' => 100, 'y' => 100})
    list.move_top_to(50)
    
    assert_equal list.relative_position.last, 150
  end
end