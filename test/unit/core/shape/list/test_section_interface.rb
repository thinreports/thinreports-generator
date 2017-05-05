# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestSectionInterface < Minitest::Test
  include Thinreports::TestHelper

  BASIC_SECTION_SCHEMA = {
    'height' => 1.0,
    'enabled' => true,
    'items' => []
  }

  # Alias
  List = Thinreports::Core::Shape::List

  def setup
    @report = Thinreports::Report.new layout: layout_file.path
  end

  def create_interface(extra_section_schema = {})
    parent = @report.start_new_page

    List::SectionInterface.new(
      parent,
      List::SectionFormat.new(BASIC_SECTION_SCHEMA.merge(extra_section_schema)),
      :section
    )
  end

  def test_internal_should_return_instance_of_SectionInternal
    assert_instance_of List::SectionInternal, create_interface.internal
  end

  def test_initialize_should_properly_set_the_specified_section_name_to_internal
    assert_equal create_interface.internal.section_name, :section
  end

  def test_initialize_should_properly_initialize_manager
    assert_instance_of Thinreports::Core::Shape::Manager::Internal,
                       create_interface.manager
  end

  def test_height_should_operate_as_delegator_of_internal
    list = create_interface('height' => 100)
    assert_same list.height, list.internal.height
  end

  def test_copied_interface_should_succeed_an_section_name_of_original
    list = create_interface
    new_parent = @report.start_new_page

    assert_same list.copy(new_parent).internal.section_name,
                list.internal.section_name
  end

  def test_copied_interface_should_have_all_the_copies_of_Shape_which_original_holds
    list = create_interface
    copied_list(list) do |new_list|
      assert_equal new_list.manager.shapes.size, 3
    end
  end

  def copied_list(list, &block)
    tblock = Thinreports::Core::Shape::TextBlock
    new_parent = @report.start_new_page

    %w( foo bar hoge ).each do |id|
      list.manager.format.shapes[id.to_sym] = tblock::Format.new('type' => 'text-block', 'id' => id)
      list.item(id).value(10)
    end

    block.call(list.copy(new_parent))
  end
end
