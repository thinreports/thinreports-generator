# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestSectionInternal < Minitest::Test
  include Thinreports::TestHelper

  BASIC_SECTION_SCHEMA = {
    'height' => 1.0,
    'enabled' => true,
    'items' => []
  }

  # Alias
  List = Thinreports::Core::Shape::List

  def create_internal(extra_section_schema = {})
    report = Thinreports::Report.new layout: layout_file.path

    List::SectionInternal.new(
      report,
      List::SectionFormat.new(BASIC_SECTION_SCHEMA.merge(extra_section_schema))
    )
  end

  def test_height_should_operate_as_delegator_of_format
    list = create_internal('height' => 100)
    assert_same list.height, list.format.height
  end

  def test_relative_left_should_operate_as_delegator_of_format
    list = create_internal('translate' => {'x' => 10})
    assert_same list.relative_left, list.format.relative_left
  end

  def test_move_top_to_should_properly_set_value_to_states_as_relative_top
    list = create_internal
    list.move_top_to(200)

    assert_equal list.states[:relative_top], 200
  end

  def test_relative_top
    list = create_internal('translate' => { 'y' => 100 })
    assert_equal 0, list.relative_top

    list.move_top_to 50
    assert_equal 50, list.relative_top
  end
end
