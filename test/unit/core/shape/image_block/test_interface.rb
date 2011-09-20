# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::ImageBlock::TestInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  ImageBlock = ThinReports::Core::Shape::ImageBlock
  
  def setup
    @interface = ImageBlock::Interface.new(flexmock('parent'),
                                           ImageBlock::Format.new({}))
  end
  
  def test_src_should_work_the_same_as_value_method
    @interface.src('/path/to/image.png')
    assert_equal @interface.src, '/path/to/image.png'
  end
  
  def test_properly_initialized_internal_property
    assert_instance_of ImageBlock::Internal, @interface.internal
  end
end