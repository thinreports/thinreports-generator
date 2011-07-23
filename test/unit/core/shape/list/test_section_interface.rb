# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestSectionInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def setup
    parent = flexmock('parent')
    format = flexmock('format')
    
    @interface = List::SectionInterface.new(parent, format, :section)
  end
  
  def test_undef_list_method
    refute_respond_to @interface, :list
  end
  
  def test_internal
    assert_instance_of List::SectionInternal, @interface.internal
  end
  
  def test_properly_set_init_item_handler
    shape_format = flexmock('shape_format')
    
    flexmock(ThinReports::Core::Shape).
      should_receive(:Interface).with(@interface, shape_format).once
      
    @interface.manager.init_item(shape_format)
  end
  
  def test_copy
    original_foo = flexmock('original_foo')
    copied_foo   = flexmock('copied_foo')

    flexmock(original_foo).
      should_receive(:copy).and_return(copied_foo).once
    @interface.manager.shapes[:foo] = original_foo
    
    copied_interface = @interface.copy(flexmock('new_parent'))
    
    assert_instance_of List::SectionInterface, copied_interface
    refute_equal @interface.object_id, copied_interface.object_id
    
    assert_equal copied_interface.internal.section_name,
                 @interface.internal.section_name
    assert_same copied_interface.manager.shapes[:foo], copied_foo
  end
end