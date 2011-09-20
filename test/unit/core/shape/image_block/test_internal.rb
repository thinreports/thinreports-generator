# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::ImageBlock::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  ImageBlock = ThinReports::Core::Shape::ImageBlock
  
  def test_src_should_return_the_same_value_as_value_method
    internal = init_internal
    internal.write_value('/path/to/image.png')
    
    assert_same internal.src, internal.read_value
  end
  
  def test_type_of_asker_should_return_true_when_iblock_value_is_given
    assert_equal init_internal.type_of?(:iblock), true
  end
  
  def test_type_of_asker_should_return_true_when_block_value_is_given
    assert_equal init_internal.type_of?(:block), true
  end
  
  def init_internal
    ImageBlock::Internal.new(flexmock('parent'), ImageBlock::Format.new({}))
  end
end