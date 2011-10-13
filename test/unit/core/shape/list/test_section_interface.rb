# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestSectionInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def create_interface(format_config = {})
    List::SectionInterface.new(flexmock('parent'),
                               List::SectionFormat.new(format_config),
                               :section)
  end
  
  def test_internal_should_return_instance_of_SectionInternal
    assert_instance_of List::SectionInternal, create_interface.internal
  end
  
  def test_initialize_should_properly_set_the_specified_section_name_to_internal
    assert_equal create_interface.internal.section_name, :section
  end
  
  def test_initialize_should_properly_initialize_manager
    assert_instance_of ThinReports::Core::Shape::Manager::Internal,
                       create_interface.manager
  end
  
  def test_height_should_operate_as_delegator_of_internal
    list = create_interface('height' => 100)
    assert_same list.height, list.internal.height
  end
  
  def test_copied_interface_should_succeed_an_section_name_of_original
    list = create_interface
    assert_same list.copy(flexmock('new_parent')).internal.section_name,
                list.internal.section_name
  end
  
  def test_copied_interface_should_have_all_the_copies_of_Shape_which_original_holds
    list = create_interface
    copied_list(list) do |new_list|
      assert_equal new_list.manager.shapes.size, 3
    end
  end
  
  def copied_list(list, &block)
    tblock     = ThinReports::Core::Shape::TextBlock
    new_parent = flexmock('new_parent')
    
    %w( foo bar hoge ).each do |id|
      list.manager.format.shapes[id.to_sym] = tblock::Format.new('type' => 's-tblock', 'id' => id)
      list.item(id).value(10)
    end
    
    block.call(list.copy(new_parent))
  end
end