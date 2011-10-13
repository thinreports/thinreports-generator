# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  # Alias
  Basic = ThinReports::Core::Shape::Basic
  
  def create_interface(format_config = {})
    Basic::Interface.new(flexmock('parent'),
                         Basic::Format.new(format_config))
  end
  
  def setup
    format = flexmock('format')
    format.should_receive(:display? => true)
    
    @basic = Basic::Interface.new(flexmock('parent'), format)
  end
  
  def test_id_should_return_id_with_reference_to_internal
    basic = create_interface('id' => 'foo')
    assert_equal basic.id, basic.internal.id
  end
  
  def test_id_should_return_cloned_id
    basic = create_interface('id' => 'basic-id')
    refute_same basic.id, basic.internal.id
  end
  
  def test_type_should_operate_as_delegator_of_internal
    basic = create_interface('type' => 's-rect')
    assert_same basic.type, basic.internal.type
  end
  
  def test_visible_asker_should_return_result_with_reference_to_style_of_internal
    basic = create_interface('display' => 'false')
    assert_equal basic.visible?, basic.internal.style.visible
  end
  
  def test_visible_should_properly_set_visibility_to_style_of_internal
    basic = create_interface('display' => 'false')
    basic.visible(true)
    
    assert_equal basic.internal.style.visible, true
  end
  
  def test_style_should_operate_as_reader_when_one_argument_is_given
    basic = create_interface('svg' => {'attrs' => {'fill' => '#ff0000'}})
    
    assert_equal basic.style(:fill_color), '#ff0000'
  end
  
  def test_style_should_operate_as_writer_when_two_arguments_are_given
    basic = create_interface
    basic.style(:border_color, '#000000')
    
    assert_equal basic.style(:border_color), '#000000'
  end
  
  def test_style_should_operate_as_writer_for_border_style_when_three_arguments_are_given
    basic = create_interface
    basic.style(:border, 1, '#ffffff')
    
    assert_equal basic.style(:border), [1, '#ffffff']
  end
  
  def test_style_should_return_self_when_two_arguments_are_given
    assert_instance_of Basic::Interface, create_interface.style(:border_width, 1)
  end
  
  def test_style_should_return_self_when_three_arguments_are_given
    assert_instance_of Basic::Interface, create_interface.style(:border, 1, '#000000')
  end
  
  def test_styles_should_properly_set_the_specified_styles_as_Hash
    basic = create_interface
    basic.styles(:fill_color   => '#ff0000',
                 :border_color => '#000000',
                 :border_width => 5,
                 :visible      => false)
    
    assert_equal [basic.style(:fill_color),
                  basic.style(:border_color),
                  basic.style(:border_width),
                  basic.style(:visible)],
                 ['#ff0000', '#000000', 5, false]
  end
  
  def test_styles_should_return_self
    basic = create_interface
    assert_instance_of Basic::Interface, basic.styles(:fill => '#ff0000')
  end
  
  def test_hide_should_properly_set_false_to_visibility
    basic = create_interface
    basic.hide
    
    assert_equal basic.visible?, false
  end
  
  def test_hide_should_return_self
    assert_instance_of Basic::Interface, create_interface.hide
  end
  
  def test_show_should_properly_set_true_to_visibility
    basic = create_interface
    basic.show
    
    assert_equal basic.visible?, true
  end
  
  def test_show_should_return_self
    assert_instance_of Basic::Interface, create_interface.show
  end
end