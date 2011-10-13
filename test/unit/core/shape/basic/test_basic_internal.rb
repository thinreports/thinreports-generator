# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Basic::TestBlockInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  Basic = ThinReports::Core::Shape::Basic
  
  def test_box_should_return_value_of_format
    internal = init_internal('box' => 'box of format')
    assert_equal internal.box, 'box of format'
  end
  
  def test_read_value_should_return_value_from_format
    internal = init_internal('value' => 'default value')
    assert_equal internal.read_value, 'default value'
  end
  
  def test_read_value_should_return_value_from_state_with_value_key
    internal = init_internal
    internal.states[:value] = 'new value'
    assert_equal internal.read_value, 'new value'
  end
  
  def test_real_value_should_return_the_same_value_as_a_read_value_method
    internal = init_internal
    internal.states[:value] = 'foo'
    assert_same internal.real_value, internal.read_value
  end
  
  def test_write_value_should_save_value_to_states_store_as_value
    internal = init_internal
    internal.write_value('new value')
    assert_equal internal.states[:value], 'new value'
  end
  
  def test_type_of_asker_should_return_true_when_given_the_block_value
    assert_equal init_internal.type_of?(:block), true
  end
  
  def test_value_should_works_the_same_as_read_value_method
    internal = init_internal
    internal.write_value('new value')
    assert_same internal.read_value, internal.value
  end
  
  def test_type_of_asker_should_return_false_otherwise
    assert_equal [:iblock, :tblock, :text, :list].all? {|t| !init_internal.type_of?(t)}, true
  end
  
  def init_internal(format = {})
    Basic::BlockInternal.new(flexmock('parent'), Basic::BlockFormat.new(format))
  end
end