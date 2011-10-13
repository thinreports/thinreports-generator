# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Basic = ThinReports::Core::Shape::Basic
  
  def create_internal(format_config = {})
    Basic::Internal.new(flexmock('parent'),
                         Basic::Format.new(format_config))
  end
  
  def test_id_should_operate_as_delegator_of_format
    basic = create_internal('id' => 'basic-id')
    assert_same basic.id, basic.format.id
  end
  
  def test_svg_tag_should_operate_as_delegator_of_format
    basic = create_internal('svg' => {'tag' => 'rect'})
    assert_same basic.svg_tag, basic.format.svg_tag
  end
  
  def test_type_should_operate_as_delegator_of_format
    basic = create_internal('type' => 's-ellipse')
    assert_same basic.type, basic.format.type
  end
  
  def test_style_should_return_instance_of_StyleGraphic
    assert_instance_of ThinReports::Core::Shape::Style::Graphic,
                       create_internal.style
  end
  
  def test_type_of_asker_should_already_return_true_when_the_specified_type_is_basic
    assert_equal create_internal.type_of?(:basic), true
  end
  
  def test_type_of_asker_should_return_true_when_the_specified_type_equal_self_type_name
    result = []
    
    result << create_internal('type' => 's-rect').type_of?(:rect)
    result << create_internal('type' => 's-ellipse').type_of?(:ellipse)
    result << create_internal('type' => 's-line').type_of?(:line)
    result << create_internal('type' => 's-image').type_of?(:image)
    
    assert_equal result.all?, true
  end
end